import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'mqtt_manager.dart'; // Import your MQTT manager

class FirePage extends StatefulWidget {
  @override
  _FirePageState createState() => _FirePageState();
}

class _FirePageState extends State<FirePage> {
  final topicController = TextEditingController();
  final List<String> _messages = [];
  final List<ChartData> _chartData = [];
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  String? _currentTopic;
  double _currentReading = 0.0;

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
    mqttClientWrapper.onMessageReceived = (message) {
      setState(() {
        _messages.add(message);
        try {
          _currentReading = double.parse(message);
          _chartData.add(ChartData(DateTime.now(), _currentReading));
          if (_chartData.length > 20) {
            _chartData.removeAt(0);
          }
        } catch (e) {
          print('Error parsing message to double: $e');
        }
      });
      print('Message received: $message');
    };
  }

  void _subscribeToTopic(String topic) {
    topic = "sensors/flame";
    if (topic.isNotEmpty && topic != _currentTopic) {
      mqttClientWrapper.subscribeToTopic(topic);
      _currentTopic = topic;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the background gradient based on the current reading
    final gradientColors = _currentReading == 0
        ? [
            Color.fromARGB(255, 6, 5, 49),
            Color(0xFFdbc6b0),
          ]
        : [
            Colors.black,
            Colors.red,
            Colors.orange,
            Colors.yellow,
          ];

    // Define button gradient based on the current reading
    final buttonGradientColors = _currentReading == 1
        ? [
            Colors.red,
            Colors.orange,
          ]
        : [
            Color(0xFFdbc6b0),
            Color(0xFF78809d),
          ];

    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[

                SizedBox(height: 272), 

                // Conditionally display the animation
                if (_currentReading == 1)
                  Lottie.asset('assets/fire2.json', width: 500, height: 200),
                if (_currentReading == 0)
                  Lottie.asset('assets/true.json', width: 500, height: 200),

                SizedBox(height: 20),

                // Custom gradient button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: buttonGradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () {
                      final topic = topicController.text;
                      _subscribeToTopic(topic);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.transparent, // Make the button background transparent
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                      minimumSize: Size(300, 50), // Set minimum size
                    ),
                    child: Text(
                      'Show home state',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Current Reading: $_currentReading',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_messages[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Positioned home icon at the top left
          Positioned(
            top: 30,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.popAndPushNamed(context, '/home');
              },
              child: Icon(
                Icons.home,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.time, this.value);
  final DateTime time;
  final double value;
}
