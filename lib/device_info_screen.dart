import 'package:flutter/material.dart';

class DeviceInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Info')),
      body: Center(
        child: Text('Device Info Screen', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
