import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_2/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'signup.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'services/flutter_storage.dart';
import 'home_page_owner.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'forgot_password.dart';

// Secure storage for JWT token
final storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Email and password cannot be empty.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final apiUrl =
        kIsWeb ? 'http://localhost:8000/login' : 'http://10.0.2.2:8000/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'username': email, 'password': password},
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['access_token'];

      // ✅ Store the token
      await SecureStorage.storage.write(key: 'access_token', value: token);
      print("🔹 Token Stored: $token");

      // ✅ Store the email
      await SecureStorage.storage.write(key: 'email', value: email);
      print("🔹 Email Stored: $email");

      // ✅ Decode the token to extract `user_type`
      try {
        final jwt = JWT.decode(token);
        String? userType = jwt.payload['user_type'];
        String? userId = jwt.payload['user_id'];

        if (userType != null && userId != null) {
          await SecureStorage.storage.write(key: 'user_type', value: userType);
          await SecureStorage.storage.write(
            key: 'user_id',
            value: userId,
          );
          print("User Type: $userType");
          print("User ID: $userId");

          // ✅ Navigate based on user type
          if (userType == 'owner') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePageOwner()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        } else {
          print("❌ Failed to decode user_type or user_id");
          _showErrorDialog("Failed to retrieve user information.");
        }
      } catch (e) {
        print("❌ JWT Decode Error: $e");
        _showErrorDialog("Invalid token received.");
      }
    } else {
      _showErrorDialog("Invalid email or password.");
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Login Failed"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
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

            const Text(
              "Login",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Email Field
            const Text("Email"),
            const SizedBox(height: 5),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter your email",
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
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Enter your password",
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
                onPressed: _isLoading ? null : _login,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),

            // Sign Up Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                  );
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
