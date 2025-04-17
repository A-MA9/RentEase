import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_page.dart';
import 'home_page_owner.dart';
import 'utils/loading_animations.dart';
import 'services/flutter_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a slight delay for the splash screen to be visible
    Future.delayed(const Duration(seconds: 2), () {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Check if user is logged in by looking for access token
    String? token = await SecureStorage.storage.read(key: 'access_token');
    
    if (token != null) {
      // User is logged in, check user type
      String? userType = await SecureStorage.storage.read(key: 'user_type');
      
      if (userType == 'owner') {
        // Navigate to owner homepage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePageOwner()),
        );
      } else {
        // Navigate to seeker homepage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      // No token found, user is not logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.brown.shade700,
              Colors.grey.shade300,
              Colors.brown.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              LoadingAnimations.secondaryLoading(
                color: Colors.white,
                size: 30.0,
              ),
              const SizedBox(height: 20),
              const Text(
                "RentEase",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
