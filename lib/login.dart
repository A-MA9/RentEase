import 'package:flutter/material.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button (←) Navigates to SignUpScreen
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
            ),

            const SizedBox(height: 10),

            // Login Title
            const Text(
              "Login",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Phone Number Field
            const Text("Phone Number"),
            const SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                hintText: "Type your number",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Password Field
            const Text("Password"),
            const SizedBox(height: 5),
            TextField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Type your password",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Handle Login
                },
                child: const Text("Login", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),

            // Sign Up Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don’t have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: const Text(
                    "Sign up now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Forgot Password
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle Forgot Password
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
