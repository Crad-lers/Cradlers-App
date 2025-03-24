import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Color customTeal = const Color(0xFF3BBEBB);
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: customTeal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPasswordInput(_currentPasswordController, 'Current Password'),
            const SizedBox(height: 10),
            _buildPasswordInput(_newPasswordController, 'New Password'),
            const SizedBox(height: 10),
            _buildPasswordInput(_confirmPasswordController, 'Confirm New Password'),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(backgroundColor: customTeal),
                    child: const Text('Update Password'),
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
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      _showSnackbar('New password and confirmation do not match.');
      return;
    }

    if (newPassword.length < 6) {
      _showSnackbar('Password should be at least 6 characters long.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not logged in.',
        );
      }

      // Reauthenticate the user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      setState(() => _isLoading = false);
      _showSnackbar('Password successfully updated.', isSuccess: true);
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = 'Error: ${e.message}';
      if (e.code == 'wrong-password') {
        errorMessage = 'Current password is incorrect.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many attempts. Try again later.';
      }
      _showSnackbar(errorMessage);
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackbar('Unexpected error: $e');
    }
  }

  void _showSnackbar(String message, {bool isSuccess = false}) {
    final color = isSuccess ? Colors.green : Colors.red;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}