import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo-wo-bg.png', height: 100),
            const SizedBox(height: 20),
            const Text(
              'Cradlers',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF22C3C8), // Teal color from logo
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Embrace Comfort, Elevate Style',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Color(0xFF22C3C8), // Match branding color
            ),
          ],
        ),
      ),
    );
  }
}
