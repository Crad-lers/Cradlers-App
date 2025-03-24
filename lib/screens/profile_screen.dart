import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'changepasswordscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;

  String name = "";
  String email = "";

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          setState(() {
            name = data['name'] ?? '';
            email = user.email ?? '';
            _phoneController.text = data['phone'] ?? '';
            _locationController.text = data['location'] ?? '';
            _bioController.text = data['bio'] ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfileChanges() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'phone': _phoneController.text.trim(),
          'location': _locationController.text.trim(),
          'bio': _bioController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = isDarkMode ? Colors.grey[900] : Colors.grey[100];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                  : [const Color(0xFF3CCBCC), const Color(0xFF3AAFA9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 15),
                  _buildEditableProfileInfoCard(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _saveProfileChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3CCBCC),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    ),
                    child: const Text('Save Changes'),
                  ),
                  const SizedBox(height: 15),
                  _buildSettingsOptions(context),
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
          colors: isDarkMode
              ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
              : [const Color(0xFF3CCBCC), const Color(0xFF3AAFA9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
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
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/user_avatar.jpg'),
            ),
          ),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(email, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildEditableProfileInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildEditableField("Phone", _phoneController),
            _buildDivider(),
            _buildEditableField("Location", _locationController),
            _buildDivider(),
            _buildEditableField("Bio", _bioController),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.black12, height: 12);
  }

  Widget _buildSettingsOptions(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        children: [
          _buildSettingsTile(context, Icons.lock, "Change Password", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePasswordScreen()));
          }),
          _buildDivider(),
          _buildSettingsTile(context, Icons.notifications, "Notifications", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Notifications tapped")),
            );
          }),
          _buildDivider(),
          _buildSettingsTile(context, Icons.exit_to_app, "Logout", () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          }, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.black87, size: 24),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: isLogout ? Colors.red : Colors.black87),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
