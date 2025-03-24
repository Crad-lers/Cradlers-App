import 'package:cradlers2/camera_view.dart';
import 'package:cradlers2/health_screen.dart';
import 'package:cradlers2/play_music_screen.dart';
import 'package:cradlers2/settings_page.dart';
import 'package:cradlers2/swing_control_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isCradleOn = false;
  final DatabaseReference _cradleRef = FirebaseDatabase.instance.ref().child('cradle');

  @override
  void initState() {
    super.initState();
    _listenToCradlePower();
  }

  void _listenToCradlePower() {
    _cradleRef.child('power').onValue.listen((event) {
      final newState = event.snapshot.value == true;
      setState(() {
        _isCradleOn = newState;
      });
    });
  }

  void _toggleCradlePower() {
    final newState = !_isCradleOn;
    _cradleRef.child('power').set(newState);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newState ? 'Cradle turned ON' : 'Cradle turned OFF'),
        backgroundColor: newState ? Colors.green : Colors.red,
      ),
    );
  }

  List<Map<String, dynamic>> get _buttonData => [
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => CameraViewPage()));
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
          'label': "Control Limit",
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
        {
          'label': _isCradleOn ? "Turn Off Cradle" : "Turn On Cradle",
          'icon': _isCradleOn ? Icons.power_settings_new : Icons.power,
          'onTap': (BuildContext context) => () => _toggleCradlePower(),
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
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
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  color: Colors.white.withOpacity(0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Column(
                        children: [
                          Image.asset('assets/logo.png', height: 50),
                          const Text(
                            "Cradlers",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
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
                          itemCount: _buttonData.length,
                          itemBuilder: (context, index) {
                            final button = _buttonData[index];
                            return _buildDashboardButton(
                              button['label'],
                              button['icon'],
                              button['onTap'](context),
                              isPowerButton: button['label'].toString().contains("Cradle"),
                              isOn: _isCradleOn,
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

  Widget _buildDashboardButton(String label, IconData icon, VoidCallback onTap,
      {bool isPowerButton = false, bool isOn = false}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isPowerButton
              ? (isOn ? Colors.green.shade100 : Colors.red.shade100)
              : Colors.white.withOpacity(0.95),
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
            Icon(icon, size: 40, color: isPowerButton ? (isOn ? Colors.green : Colors.red) : Colors.black54),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPowerButton ? (isOn ? Colors.green[800] : Colors.red[800]) : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
