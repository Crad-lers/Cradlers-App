import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Ensure the title is centered
        title: Image.asset('assets/logo-wo-bg.png', height: 56), // Adjust the height as needed
        backgroundColor: Colors.white, // You can change this as per your color scheme
        elevation: 0, // Removes the shadow under the AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'CRADLers',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF39CCCC), // Custom color for "Cradlers"
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Space between text and button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/devices');
              },
              child: const Text('View Devices'),
            ),
            SizedBox(height: 20), // Space after the first button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/thankyou');
              },
              child: const Text('Thank You Page'),
            ),
          ],
        ),
      ),
    );
  }
}
