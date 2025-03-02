import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows body content to extend behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,  // Makes AppBar background transparent
        elevation: 0,  // Removes shadow from AppBar
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,  // Ensures the background color is consistent
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo-wo-bg.png', height: 180),  // Displaying the logo in the body
              SizedBox(height: 40),  // Space between logo and text
              Text(
                'Welcome to',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                'Cradlers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39CCCC), // Specific teal color for "Cradlers"
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),  // Space between text and the first button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/devices');
                },
                child: const Text('View Devices'),
              ),
              SizedBox(height: 20),  // Space between the first and second button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/thankyou');
                },
                child: const Text('Thank You Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
