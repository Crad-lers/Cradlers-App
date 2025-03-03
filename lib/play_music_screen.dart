import 'package:flutter/material.dart';

class PlayMusicScreen extends StatefulWidget {
  const PlayMusicScreen({super.key});

  @override
  _PlayMusicScreenState createState() => _PlayMusicScreenState();
}

class _PlayMusicScreenState extends State<PlayMusicScreen> {
  List<String> tracks = ["Track 1", "Track 2", "Track 3"];
  String activeTrack = "Track 1"; // Default active track
  int maxTracks = 6; // Maximum number of tracks

  // Extracted brand color from the logo
  final Color primaryColor = const Color(0xFF22C3C8); // Teal from your logo
  final Color secondaryColor = const Color(0xFF198F94); // Darker teal for contrast

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 50), // Logo
              ],
            ),
            const SizedBox(height: 20),

            // Page Title
            const Text(
              "Play Music",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 25),

            // Active Track Indicator
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "Now Playing - $activeTrack",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Track Buttons
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...tracks.map((track) {
                    bool isActive = track == activeTrack;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10), // Increased spacing
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: isActive
                              ? LinearGradient(colors: [primaryColor, secondaryColor])
                              : null,
                          boxShadow: isActive
                              ? [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ]
                              : [],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              activeTrack = track;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isActive ? Colors.transparent : Colors.grey[300],
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: Text(
                            track,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  // Add Track Button
                  if (tracks.length < maxTracks)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10), // Increased spacing
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (tracks.length < maxTracks) {
                                tracks.add("Track ${tracks.length + 1}");
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor.withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: const Text(
                            "+ Add Track",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
