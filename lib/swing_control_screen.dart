import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SwingControlScreen extends StatefulWidget {
  const SwingControlScreen({super.key});

  @override
  State<SwingControlScreen> createState() => _SwingControlScreenState();
}

class _SwingControlScreenState extends State<SwingControlScreen> {
  String swingMode = "Auto"; // Default mode is Auto
  bool musicWhileSwinging = false; // Default music OFF

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("controls");

  @override
  void initState() {
    super.initState();
    // Update Firebase with initial mode and music status
    _updateFirebase();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateFirebase() {
    String firebaseCommand = swingMode == "Auto" ? "SWING_AUTO" : swingMode;
    _dbRef.update({
      "swing_status": firebaseCommand,  // Send "SWING_AUTO" if Auto is selected
      "music_status": musicWhileSwinging,
    }).then((_) {
      print("✅ Firebase updated with swing status: $firebaseCommand");
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 24),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/logo.png', // Make sure to replace this with your actual logo asset path
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
                "Swing Control",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            _buildSwingButton("Auto"),
            const SizedBox(height: 15),
            _buildSwingButton("ON"),
            const SizedBox(height: 15),
            _buildSwingButton("OFF"),
            const SizedBox(height: 40),
            const Text(
              "Music While Swinging",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
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

    return GestureDetector(
      onTap: () {
        setState(() {
          swingMode = label;
          _updateFirebase();  // Push changes to Firebase
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueGrey : Colors.grey[800]!,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [BoxShadow(
            color: Colors.blueGrey.withOpacity(0.6),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
          _updateFirebase(); // Push changes to Firebase
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? (value ? Colors.green : Colors.red) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey),
          boxShadow: isSelected
              ? [BoxShadow(
            color: (value ? Colors.green : Colors.red).withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )]
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