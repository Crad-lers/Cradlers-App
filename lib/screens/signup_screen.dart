import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../forgot_password_screen.dart';
import './login_screen.dart'; // 👈 Make sure this exists if you use push instead of named route

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool obscurePassword = true;
  bool isLoading = false;

  final Color primaryColor = const Color(0xFF22C3C8);
  final Color textColor = Colors.black87;

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10,}$').hasMatch(phone);
  }

  Future<void> registerUser() async {
    setState(() => isLoading = true);
    FocusScope.of(context).unfocus(); // Dismiss keyboard

    try {
      print("✅ Creating user...");
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("✅ Storing user data...");
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // Optional: Uncomment if you're handling email verification
      // await userCredential.user!.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully.")),
      );

      await Future.delayed(const Duration(seconds: 1)); // let user see the snackbar

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This email is already registered.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'weak-password':
          errorMessage = "Password must be at least 6 characters.";
          break;
        default:
          errorMessage = e.message ?? "Registration failed.";
      }

      print("❌ Firebase error: $errorMessage");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      print("❌ Unknown error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset("assets/logo-wo-bg.png", height: 100),
                  const SizedBox(height: 20),
                  Text(
                    'Create Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: nameController,
                    label: 'Full Name',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Please enter your name";
                      if (value.trim().length < 3) return "Name must be at least 3 characters";
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildTextField(
                    controller: emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Please enter your email";
                      if (!isValidEmail(value.trim())) return "Enter a valid email address";
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Please enter your phone number";
                      if (!isValidPhone(value.trim())) return "Enter a valid phone number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: _buildInputDecoration('Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() => obscurePassword = !obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Please enter a password";
                      if (value.length < 6) return "Password must be at least 6 characters";
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        registerUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: primaryColor),
                    child: const Text('Forgot Password?'),
                  ),

                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _buildInputDecoration(label),
      validator: validator,
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: primaryColor.withOpacity(0.1),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }
}
