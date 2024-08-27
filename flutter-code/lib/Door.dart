import 'package:flutter/material.dart';
import 'mqtt_manager.dart'; // Import your MQTT manager

class DoorPage extends StatefulWidget {
  @override
  _DoorPageState createState() => _DoorPageState();
}

class _DoorPageState extends State<DoorPage> {
  final topicController = TextEditingController();
  final List<String> _messages = [];
  final List<ChartData> _chartData = [];
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  String? _currentTopic;
  double _currentReading = 0.0;
  bool _isOn = false; // Track the button state

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
    topic = "door/control";
    if (topic.isNotEmpty && topic != _currentTopic) {
      mqttClientWrapper.subscribeToTopic(topic);
      _currentTopic = topic;
    }
  }

  void _toggleSwitch(bool value) {
    setState(() {
      _isOn = value;
      // Publish message based on switch state
      final message = _isOn ? 'OPEN' : 'CLOSE';
      mqttClientWrapper.publishMessage("door/control", message);
      print('Switch is ${_isOn ? "On" : "Off"} - Published: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 6, 5, 49),
              Color(0xFFdbc6b0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Image.asset(
                  _isOn ? 'assets/opend.png' : 'assets/closed.png',
                  width: 100,  // Set the width
                  height: 500, // Set the height
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 300.0), // Adjust the bottom padding to move the switch up or down
                  child: Transform.scale(
                    scale: 1.5, // Adjust the scale factor to make the switch larger
                    child: Switch(
                      value: _isOn,
                      onChanged: _toggleSwitch,
                      activeColor: Color.fromARGB(255, 155, 139, 122),
                      inactiveThumbColor: Color.fromARGB(255, 6, 5, 49),
                      inactiveTrackColor:Color(0xFF4d6489),
                      activeTrackColor: Color(0xFFdbc6b0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder for ChartData class
class ChartData {
  final DateTime time;
  final double value;

  ChartData(this.time, this.value);
}
