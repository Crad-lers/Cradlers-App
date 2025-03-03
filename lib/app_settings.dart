import 'package:flutter/material.dart';

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account Details'),
          _buildListTile('Profile', Icons.person, () {
            Navigator.pushNamed(context, '/profile');
          }),
          _buildListTile('Email', Icons.email, () {
            Navigator.pushNamed(context, '/email');
          }),
          _buildListTile('Password', Icons.lock, () {
            Navigator.pushNamed(context, '/password');
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
            title: Text('Push Notifications'),
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
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
