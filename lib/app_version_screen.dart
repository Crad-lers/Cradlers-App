import 'package:flutter/material.dart';

class AppVersionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Version')),
      body: Center(
        child: Text('App Version: 1.0.0', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
