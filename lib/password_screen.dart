import 'package:flutter/material.dart';

class PasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Center(
        child: Text('Password Screen', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
