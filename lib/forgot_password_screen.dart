import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool emailSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),

            // Logo
            Image.asset(
              'assets/logo-wo-bg.png', // Replace with actual logo path
              height: 80,
            ),

            const SizedBox(height: 20),

            // Success Message (Only visible when email is sent)
            if (emailSent)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: const Text(
                  "Reset instructions have been sent to the email. Check your inbox.",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),

            if (emailSent) const SizedBox(height: 10),

            // Forgot Password Heading
            const Text(
              "Forgot Password ?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Subtext
            const Text(
              "No worries. We’ll send you reset instructions.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Email Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  // Email Input Field with Validation
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Reset Password Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      emailSent = true; // Show success message
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3CCBCC), // Teal color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Back to Login
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context); // Go back to login screen
              },
              icon: const Icon(Icons.arrow_back, size: 16, color: Colors.black54),
              label: const Text(
                "Back to Login",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
