import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Make sure this is created and correctly located

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key}); // Added super.key for best practice

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
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
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
            value: true,
            onChanged: (bool value) {},
          ),
          _buildSectionHeader('About'),
          _buildListTile('Device Info', Icons.info, () {
            Navigator.pushNamed(context, '/deviceinfo');
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
