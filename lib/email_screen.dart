import 'package:flutter/material.dart';

class EmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email')),
      body: Center(
        child: Text('Email Screen', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
