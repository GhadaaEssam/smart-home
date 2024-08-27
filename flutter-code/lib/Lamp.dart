import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'mqtt_manager.dart';
// Update with your actual package path

class LightingPage extends StatefulWidget {
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<LightingPage> {
  final Color primaryColor = const Color.fromARGB(255, 6, 5, 49);
  final Color secondaryColor = const Color(0xFFdbc6b0);
  bool _isOn = false; // Track the toggle state

  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
  }

  void _toggleSwitch() {
    setState(() {
      _isOn = !_isOn; // Toggle the state
      String message = _isOn ? 'on' : 'off';
      // Publish the message to the 'light' topic
      mqttClientWrapper.publishMessage('led/brightness', message); // Ensure the topic is 'light'
      print("Toggled switch: $_isOn, sending '$message' to MQTT");
    });
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Center(child: SizedBox(height: 70))),
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
                  'assets/lamp.json',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Light Your Life',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ),
              SizedBox(height: 80),
              Center(
                child: Icon(
                  Icons.lightbulb,
                  color: _isOn ? Colors.white : primaryColor,
                  size: 150,
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _toggleSwitch,
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isOn ? secondaryColor : primaryColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            left: _isOn ? 50 : 0,
                            top: 0,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _isOn ? 'On' : 'Off',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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