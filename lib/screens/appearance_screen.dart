import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class AppearanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Appearance Settings'),
      ),
      body: SwitchListTile(
        title: Text('Dark Mode'),
        value: isDarkMode,
        onChanged: (bool value) {
          themeProvider.toggleTheme(value);
        },
      ),
    );
  }
}
