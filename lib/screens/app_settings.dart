import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Ensure this is correctly located and implemented

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool isNotificationsEnabled = true; // Default value for notifications toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account Details'),
          _buildListTile('Profile', Icons.person, () {
            Navigator.pushNamed(context, '/profile');
          }),
          _buildListTile('Change Password', Icons.lock, () {
            Navigator.pushNamed(context, '/changePassword');
          }),
          _buildSectionHeader('Preferences'),
          _buildListTile('Languages', Icons.language, () {
            Navigator.pushNamed(context, '/language');
          }),
          _buildListTile('Appearance', Icons.palette, () {
            Navigator.pushNamed(context, '/appearance');
          }),
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: isNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                isNotificationsEnabled = value;
              });
            },
          ),
          _buildSectionHeader('About'),
          _buildListTile('Device Info', Icons.system_update, () {
            Navigator.pushNamed(context, '/deviceInfo');
          }),
          _buildListTile('App Version', Icons.system_update, () {
            Navigator.pushNamed(context, '/appversion');
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
