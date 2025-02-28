import 'package:flutter/material.dart';
import 'signup.dart'; // Ensure correct import path
import 'login.dart'; // Import your login screen
import 'verification_1.dart'; // Import your verification screen

class SeekerSignUpScreen extends StatefulWidget {
  // Changed class name
  const SeekerSignUpScreen({super.key});

  @override
  _SeekerSignUpScreenState createState() => _SeekerSignUpScreenState();
}

class _SeekerSignUpScreenState extends State<SeekerSignUpScreen> {
  bool _isPasswordVisible = false; // Tracks password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
        ),
        // title: const Text("Seeker Sign Up"),
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // Profile Image
            Image.asset("assets/login.png", height: 120, width: 120),

            const SizedBox(height: 10),

            const Text(
              "Sign up as Seeker",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Full Name Field
            TextField(
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Phone Number Field
            TextField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Email Field
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Password Field with Toggle
            TextField(
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle state
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerificationScreen(userType: 0),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Need Help & Login
            Center(
              child: Column(
                children: [
                  const Text("Need Help?"),
                  TextButton(onPressed: () {}, child: const Text("Click Here")),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
