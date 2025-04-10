import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';
import 'verification_1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'services/otp_service.dart';
import 'services/flutter_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class OwnerSignUpScreen extends StatefulWidget {
  const OwnerSignUpScreen({super.key});

  @override
  _OwnerSignUpScreenState createState() => _OwnerSignUpScreenState();
}

class _OwnerSignUpScreenState extends State<OwnerSignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Function to register owner
  Future<void> _registerOwner() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Generate OTP
      final otp = OtpService.generateOtp();

      // Send OTP via email
      final otpSent = await OtpService.sendOtp(
        email: _emailController.text,
        name: _nameController.text,
        otp: otp,
      );

      if (!otpSent) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to send verification email. Please try again.',
            ),
          ),
        );
        return;
      }

      // Correct API URL for local development
      final apiUrl =
          kIsWeb
              ? 'http://localhost:8000/register/owner' // For web
              : 'http://10.0.2.2:8000/register/owner'; // For Android emulator

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'full_name': _nameController.text,
          'phone_number': _phoneController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      // Debugging: Print response status & body
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        // Store user data in secure storage
        final userData = json.decode(response.body);
        
        // Store the email
        await SecureStorage.storage.write(key: 'email', value: _emailController.text);
        
        // Store user type
        await SecureStorage.storage.write(key: 'user_type', value: 'owner');
        
        // If there's a user_id in the response, store it
        if (userData['id'] != null) {
          await SecureStorage.storage.write(key: 'user_id', value: userData['id'].toString());
        }
        
        // If there's a token in the response, store it
        if (userData['access_token'] != null) {
          final token = userData['access_token'];
          await SecureStorage.storage.write(key: 'access_token', value: token);
          
          // Try to decode the token to extract additional information
          try {
            final jwt = JWT.decode(token);
            if (jwt.payload['user_id'] != null) {
              await SecureStorage.storage.write(
                key: 'user_id', 
                value: jwt.payload['user_id']
              );
            }
          } catch (e) {
            print("Failed to decode JWT: $e");
          }
        }
        
        print("🔹 Stored user data in secure storage");
        
        // Registration successful, navigate to verification
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => VerificationScreen(
                  userType: 1,
                  email: _emailController.text,
                  fullName: _nameController.text,
                ),
          ),
        );
      } else {
        // Show error message
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['detail'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: ${e.toString()}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Profile Image
                Image.asset("assets/login.png", height: 120, width: 120),

                const SizedBox(height: 10),

                const Text(
                  "Sign up as Owner",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                // Full Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Phone Number Field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Password Field with Toggle
                TextFormField(
                  controller: _passwordController,
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
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerOwner,
                    // onPressed: () {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder:
                    //           (context) => VerificationScreen(
                    //             userType: 1,
                    //             email: _emailController.text,
                    //             fullName: _nameController.text,
                    //           ),
                    //     ),
                    //   );
                    // },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 30),

                // Need Help & Login
                Center(
                  child: Column(
                    children: [
                      const Text("Need Help?"),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Click Here"),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
