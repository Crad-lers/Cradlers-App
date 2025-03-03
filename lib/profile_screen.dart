import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false; // Dark mode toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode ? [Color(0xFF1E1E1E), Color(0xFF121212)] : [Color(0xFF3CCBCC), Color(0xFF3AAFA9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 15),
            _buildProfileInfoCard(),
            const SizedBox(height: 15),
            _buildSettingsOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode ? [Color(0xFF1E1E1E), Color(0xFF121212)] : [Color(0xFF3CCBCC), Color(0xFF3AAFA9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey[300]!,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/user_avatar.jpg'),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "John Doe",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "johndoe@example.com",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _buildInfoRow("Phone", "+123 456 7890"),
            _buildDivider(),
            _buildInfoRow("Location", "New York, USA"),
            _buildDivider(),
            _buildInfoRow("Bio", "Flutter Developer | Tech Enthusiast"),
            const SizedBox(height: 10),
            _buildEditProfileButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(fontSize: 15, color: Colors.black54)),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.black12, height: 12);
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF3CCBCC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => print("Edit Profile Clicked"),
      icon: const Icon(Icons.edit, size: 18),
      label: const Text("Edit Profile", style: TextStyle(fontSize: 14)),
    );
  }

  Widget _buildSettingsOptions() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black54,
      child: Column(
        children: [
          _buildSettingsTile(Icons.lock, "Change Password", () => print("Change Password Clicked")),
          _buildDivider(),
          _buildSettingsTile(Icons.notifications, "Notifications", () => print("Notifications Clicked")),
          _buildDivider(),
          _buildSettingsTile(Icons.dark_mode, "Dark Mode", () {
            setState(() => isDarkMode = !isDarkMode);
          }, trailing: Switch(value: isDarkMode, onChanged: (val) => setState(() => isDarkMode = val))),
          _buildDivider(),
          _buildSettingsTile(Icons.exit_to_app, "Logout", () => print("Logout Clicked"), isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {Widget? trailing, bool isLogout = false}) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.black87, size: 24),
      title: Text(title, style: TextStyle(fontSize: 16, color: isLogout ? Colors.red : Colors.black87)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
      onTap: onTap,
    );
  }
}
