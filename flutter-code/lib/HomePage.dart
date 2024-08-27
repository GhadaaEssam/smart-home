import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeapp/Distance.dart';
import 'package:homeapp/Door.dart';
import 'package:homeapp/Flame.dart';
import 'package:homeapp/Lamp.dart';
import 'package:homeapp/SignInScreen.dart';
import 'package:homeapp/SoilPage.dart';
import 'package:homeapp/StartPage.dart';
import 'package:homeapp/WeatherPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final Color primaryColor = Color.fromARGB(255, 6, 5, 49);
  final Color secondaryColor = Color(0xFFdbc6b0);
  final Color accentColor = Color(0xFF78809d);
  final Color iconColor = Color(0xFF4d6489);

  bool _isPressed = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 114), // Space from top

                Expanded(
                  child: Stack(
                    children: [
                      if (_isPressed)
                        Positioned.fill(
                          child: CustomPaint(),
                        ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            size: 80,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30), // Space before grid
                          Expanded(
                            child: GridView.count(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              crossAxisCount: 2,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                              children: [
                                _buildIconButton(context, Icons.location_on, LocationPage(), Colors.black),
                                _buildIconButton(context, Icons.light, LightingPage(), Colors.black),
                                _buildIconButton(context, Icons.cloud, WeatherPage(), Colors.black),
                                _buildIconButton(context, Icons.door_back_door, DoorPage(), Colors.black),
                                _buildIconButton(context, Icons.eco, SoilPage(), Colors.black),
                                _buildIconButton(context, Icons.local_fire_department, FirePage(), Colors.black),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 30,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  _showLogoutDialog(context);
                },
                child: Icon(
                  Icons.logout,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, Widget page, Color iconColor) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isPressed = true;
          _scale = 0.9;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
          _scale = 1.0;
        });
        _onButtonPressed(context, page);
      },
      child: Transform.scale(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 50,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4d6489), Color.fromARGB(255, 195, 200, 218)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15.0),
                Text(
                  "Are you sure you want to log out?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _auth.signOut(); // Sign out the user
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => StartScreen()), // Navigate to the Sign-In screen
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.grey), // Logout icon
                          SizedBox(width: 4),
                          Text(
                            "Log out",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0), // Space between buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        User? user = _auth.currentUser;
                        if (user != null) {
                          await _firestore.collection('users').doc(user.uid).delete(); // Delete user data from Firestore
                          await user.delete(); // Delete user account
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignInScreen()), // Navigate to the Sign-In screen
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.redAccent), // Delete account icon
                          SizedBox(width: 4),
                          Text(
                            "Delete Account",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
