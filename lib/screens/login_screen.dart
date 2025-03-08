import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding/decoding JSON

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  final Color primaryColor = const Color(0xFF22C3C8); // Teal from logo
  final Color textColor = Colors.black87;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Function to handle sign-in
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      // Prepare the data to send
      final Map<String, dynamic> signInData = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      try {
        // Send POST request to the backend
        final response = await http.post(
          Uri.parse('http://localhost:5000/api/auth/signin'), // Backend URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(signInData),
        );

        // Check the response status
        if (response.statusCode == 200) {
          // Success: Parse the response
          final responseData = jsonDecode(response.body);
          final String token = responseData['token'];
          final Map<String, dynamic> user = responseData['user'];

          // Save the token (e.g., using SharedPreferences)
          // Navigate to the home screen
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Handle errors
          final responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } catch (error) {
        // Handle network errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo-wo-bg.png",
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 20),
                // Email Field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: primaryColor.withOpacity(0.1),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Password Field
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: primaryColor.withOpacity(0.1),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Sign In Button
                ElevatedButton(
                  onPressed: _signIn, // Call the sign-in function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 10),
                // Sign Up Button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup'); // Navigate to SignUp
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don’t have an account? ",
                      children: [
                        TextSpan(
                          text: "Sign Up",
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
    );
  }
}