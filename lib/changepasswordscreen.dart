import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPasswordInput(_currentPasswordController, 'Current Password'),
            SizedBox(height: 10),
            _buildPasswordInput(_newPasswordController, 'New Password'),
            SizedBox(height: 10),
            _buildPasswordInput(_confirmPasswordController, 'Confirm New Password'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Update Password'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInput(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  void _changePassword() {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword == confirmPassword) {
      print('Password successfully changed.');
    } else {
      print('New password and confirm password do not match.');
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
