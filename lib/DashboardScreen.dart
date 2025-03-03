import 'package:cradlers2/health_screen.dart';
import 'package:cradlers2/play_music_screen.dart';
import 'package:cradlers2/settings_page.dart';
import 'package:cradlers2/swing_control_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CradlersDashboard());
}

class CradlersDashboard extends StatelessWidget {
  const CradlersDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cradlers Dashboard',
      theme: ThemeData(
        primaryColor: const Color(0xFF3CCBCC),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // Ensures content is within visible screen area
        child: Stack(
          children: [
            // Background Image with Responsiveness
            Positioned.fill(
              child: Image.asset(
                'assets/cradle.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.2),
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text("Image not found", style: TextStyle(color: Colors.red)),
                  );
                },
              ),
            ),

            // Content
            Column(
              children: [
                // Header with Logo and Home Icon
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  color: Colors.white.withOpacity(0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, size: 28),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 50,
                          ),
                          const Text(
                            "Cradlers",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 40), // Placeholder for alignment
                    ],
                  ),
                ),

                // Dashboard Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFF3CCBCC),
                  child: const Center(
                    child: Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Responsive Grid of Buttons
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 1,
                          ),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _buildDashboardButton(
                              _buttonData[index]['label']!,
                              _buttonData[index]['icon']!,
                              _buttonData[index]['onTap']!(context),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Button Widget with Animation
  Widget _buildDashboardButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black54),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Button Data
  static final List<Map<String, dynamic>> _buttonData = [
    {
      'label': "Health",
      'icon': Icons.favorite,
      'onTap': (BuildContext context) => () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HealthScreen()));
      },
    },
    {
      'label': "Camera",
      'icon': Icons.videocam,
      'onTap': (BuildContext context) => () {
        print("Camera Clicked");
      },
    },
    {
      'label': "Play Music",
      'icon': Icons.music_note,
      'onTap': (BuildContext context) => () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayMusicScreen()));
      },
    },
    {
      'label': "Settings",
      'icon': Icons.settings,
      'onTap': (BuildContext context) => () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
      },
    },
    {
      'label': "Swing",
      'icon': Icons.airline_seat_flat,
      'onTap': (BuildContext context) => () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SwingControlScreen()));
      },
    },
  ];
}
