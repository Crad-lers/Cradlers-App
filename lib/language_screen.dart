import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Language Preferences')),
      body: Center(
        child: Text('Language Screen', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
