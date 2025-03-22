import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SwingControlScreen extends StatefulWidget {
  const SwingControlScreen({super.key});

  @override
  State<SwingControlScreen> createState() => _SwingControlScreenState();
}

class _SwingControlScreenState extends State<SwingControlScreen> {
  String swingMode = "Auto"; // Default mode
  bool musicWhileSwinging = false; // Default music OFF

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load preferences from Firestore
  Future<void> _loadPreferences() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('userPreferences').doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          swingMode = snapshot['swingMode'] ?? 'Auto';
          musicWhileSwinging = snapshot['musicMode'] ?? false;
        });
      }
    }
  }

  // Save preferences to Firestore
  Future<void> _savePreferences() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('userPreferences').doc(user.uid).set({
        'swingMode': swingMode,
        'musicMode': musicWhileSwinging,
      });
    }
  }

  // Your Raspberry Pi backend IP
  final String baseUrl = "http://<RASPBERRY_PI_IP>:5000"; 

  // Control swing mode
  Future<void> _controlSwing(String mode) async {
    final response = await http.post(
      Uri.parse('$baseUrl/swing'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mode': mode}),
    );
    if (response.statusCode == 200) {
      print("Swing mode set to: $mode");
      setState(() {
        swingMode = mode;
      });
      _savePreferences(); // Save to Firebase
    } else {
      print("Failed to set swing mode");
    }
  }

  // Control music while swinging
  Future<void> _controlMusic(bool music) async {
    final response = await http.post(
      Uri.parse('$baseUrl/music'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'music': music}),
    );
    if (response.statusCode == 200) {
      print("Music turned ${music ? 'ON' : 'OFF'}");
      setState(() {
        musicWhileSwinging = music;
      });
      _savePreferences(); // Save to Firebase
    } else {
      print("Failed to control music");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),

            // Logo and Title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 24),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Image.asset(
                  'assets/logo.png', // Replace with actual logo path
                  height: 40,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Cradlers",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Swing Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Swing",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            // Swing Mode Buttons (Auto, ON, OFF)
            Column(
              children: [
                _buildSwingButton("Auto"),
                const SizedBox(height: 15),
                _buildSwingButton("ON"),
                const SizedBox(height: 15),
                _buildSwingButton("OFF"),
              ],
            ),

            const SizedBox(height: 40),

            // Music While Swinging Title
            const Text(
              "Music While Swinging",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // Music Toggle Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMusicToggleButton("OFF", false),
                const SizedBox(width: 15),
                _buildMusicToggleButton("ON", true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Swing Mode Button Widget (Professional Colors)
  Widget _buildSwingButton(String label) {
    bool isSelected = swingMode == label;

    Color buttonColor = Colors.grey[800]!; // Default color
    Color textColor = Colors.white;

    if (label == "ON" && isSelected) {
      buttonColor = Colors.green;
      textColor = Colors.white;
    } else if (label == "OFF" && isSelected) {
      buttonColor = Colors.red;
      textColor = Colors.white;
    } else if (label == "Auto" && isSelected) {
      buttonColor = Colors.blueGrey;
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          swingMode = label;
        });
        _controlSwing(label); // Send request to control swing
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.6),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  // Music Toggle Button Widget (Better Styling)
  Widget _buildMusicToggleButton(String label, bool value) {
    bool isSelected = musicWhileSwinging == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          musicWhileSwinging = value;
        });
        _controlMusic(value); // Send request to control music
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? (value ? Colors.green : Colors.red) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.black),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (value ? Colors.green : Colors.red).withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
