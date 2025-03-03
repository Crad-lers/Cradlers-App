import 'package:flutter/material.dart';

class AppearanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appearance Settings')),
      body: Center(
        child: Text('Appearance Screen', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
