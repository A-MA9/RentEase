import 'package:flutter/material.dart';
import 'verification_2.dart';

class VerificationScreen extends StatelessWidget {
  final int userType; // 1 = Owner, 0 = Regular User

  const VerificationScreen({Key? key, required this.userType})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Select a verification method",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // OTP via SMS
            _buildOtpOption(
              icon: const Icon(Icons.sms, color: Colors.brown),
              text: "Send OTP via SMS to ***637",
              onTap: () {
                // Handle SMS OTP request
              },
            ),

            const SizedBox(height: 15),

            // OTP via Whatsapp
            _buildOtpOption(
              icon: Image.asset(
                "assets/whatsapp.png", // Make sure this image is in your assets folder
                height: 24,
                width: 24,
              ),
              text: "Send OTP via WhatsApp to ***637",
              onTap: () {
                // Handle WhatsApp OTP request
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Verification2Screen(userType: userType),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            // OTP via Call
            _buildOtpOption(
              icon: const Icon(Icons.call, color: Colors.brown),
              text: "Send OTP via Call to ***637",
              onTap: () {
                // Handle Call OTP request
              },
            ),

            const Spacer(),

            // Need Help Text
            const Text("Select preferred method, "),
            GestureDetector(
              onTap: () {
                // Navigate to Help Page
              },
              child: const Text(
                "Need Help?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ✅ Fixed `_buildOtpOption` to accept a `Widget` instead of `IconData`
  Widget _buildOtpOption({
    required Widget icon, // Changed from `IconData` to `Widget`
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
          ],
        ),
        child: Row(
          children: [
            icon, // ✅ Now accepts `Image.asset`
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
