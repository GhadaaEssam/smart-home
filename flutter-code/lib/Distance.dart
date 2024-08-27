import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'mqtt_manager.dart';

class LocationPage extends StatefulWidget {
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<LocationPage> {
  final Color primaryColor = const Color.fromARGB(255, 6, 5, 49);
  final Color secondaryColor = const Color(0xFFdbc6b0);
  Color _buttonColor1 = const Color.fromARGB(255, 6, 5, 49);
  Color _buttonColor2 = const Color.fromARGB(255, 6, 5, 49);

  final List<String> _messages = [];
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  String? _currentTopic;
  double _currentReading = 0.0;
  String _currentMessage = 'No message :('; // Default message

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
    mqttClientWrapper.onMessageReceived = (message) {
      double reading = double.parse(message); // Parse the message to double
      setState(() {
        _messages.add(message);
        _currentReading = reading;

        // Update the message based on the current reading
        if (_currentTopic == 'sensor/long_distance' &&
            reading > 1000 &&
            _buttonColor2 == Colors.white) {
          _currentMessage = message;
        } else if (_currentTopic == 'sensor/short_distance' &&
            reading <= 1000 &&
            _buttonColor1 == Colors.white) {
          _currentMessage = message;
        }
      });
      print('Message received: $message'); // Debug print
    };
  }

  void _changeColor1() {
    setState(() {
      _buttonColor1 = _buttonColor1 == Colors.white
          ? const Color.fromARGB(255, 6, 5, 49)
          : Colors.white;

      if (_buttonColor1 == Colors.white) {
        _subscribeToTopic('sensor/short_distance');
      } else {
        // Reset message when button is not active
        _currentMessage = 'No message :(';
      }
    });
  }

  void _changeColor2() {
    setState(() {
      _buttonColor2 = _buttonColor2 == Colors.white
          ? const Color.fromARGB(255, 6, 5, 49)
          : Colors.white;

      if (_buttonColor2 == Colors.white) {
        _subscribeToTopic('sensor/long_distance');
      } else {
        // Reset message when button is not active
        _currentMessage = 'No message :(';
      }
    });
  }

  void _subscribeToTopic(String topic) {
    if (_currentTopic != topic) {
      mqttClientWrapper.subscribeToTopic(topic);
      _currentTopic = topic; // Update current topic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 40), // Add space for the home icon
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Space between text and icon
                children: [
                  Expanded(
                    child: Center(
                      child: SizedBox(
                          height: 70), // Additional space to move the icon down
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/home');
                    },
                  ),
                ],
              ),
              Center(
                child: Lottie.asset(
                  'assets/location.json', // Path to your Lottie file
                  width: 100, // Set the width of the animation
                  height: 100, // Set the height of the animation
                ),
              ),
              SizedBox(height: 10), // Space between animation and text
              Center(
                child: Text(
                  'Line Tracker Sensor',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ),
              SizedBox(height: 130), // Space between title and message
              Center(
                child: Text(
                  _currentMessage,
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Align buttons at the bottom
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _buttonColor1,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 15),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            onPressed: _changeColor1,
                            child: Text('Short Distance'),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _buttonColor2,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 15),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            onPressed: _changeColor2,
                            child: Text('Long Distance'),
                          ),
                        ],
                      ),
                      SizedBox(height: 200), // Add space below buttons
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
