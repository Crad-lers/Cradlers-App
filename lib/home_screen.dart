import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo-wo-bg.png', height: 180),
              SizedBox(height: 40),
              Text(
                'Welcome to',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Cradlers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39CCCC),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/devices'),
                child: const Text('View Devices'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/addDevice'),
                child: const Text('Add New Device'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
