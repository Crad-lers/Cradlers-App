import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SwingControlScreen extends StatefulWidget {
  const SwingControlScreen({super.key});

  @override
  State<SwingControlScreen> createState() => _SwingControlScreenState();
}

class _SwingControlScreenState extends State<SwingControlScreen> {
  String swingMode = "Auto"; // Default mode
  bool musicWhileSwinging = false; // Default music OFF

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("controls");

  void _updateFirebase() {
    _dbRef.set({
      "swing_status": swingMode,
      "music_status": musicWhileSwinging,
    }).then((_) {
      print("✅ Firebase updated");
    }).catchError((error) {
      print("❌ Failed to update Firebase: $error");
    });
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

  Widget _buildSwingButton(String label) {
    bool isSelected = swingMode == label;

    Color buttonColor = Colors.grey[800]!;
    Color textColor = Colors.white;

    if (label == "ON" && isSelected) {
      buttonColor = Colors.green;
    } else if (label == "OFF" && isSelected) {
      buttonColor = Colors.red;
    } else if (label == "Auto" && isSelected) {
      buttonColor = Colors.blueGrey;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          swingMode = label;
          _updateFirebase();  // <- Push to Firebase on change
        });
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

  Widget _buildMusicToggleButton(String label, bool value) {
    bool isSelected = musicWhileSwinging == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          musicWhileSwinging = value;
          _updateFirebase(); // <- Push to Firebase on toggle
        });
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
