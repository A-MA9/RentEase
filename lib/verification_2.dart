import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'property_type.dart';

class Verification2Screen extends StatefulWidget {
  final int userType;

  const Verification2Screen({Key? key, required this.userType})
    : super(key: key);

  @override
  State<Verification2Screen> createState() => _Verification2ScreenState();
}

class _Verification2ScreenState extends State<Verification2Screen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpEntered() {
    String otpCode = _controllers.map((e) => e.text).join();
    if (otpCode.length == 6) {
      // Check userType and navigate accordingly
      if (widget.userType == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SelectPropertyTypeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    }
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: "", // Hide counter
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(
              context,
            ).requestFocus(_focusNodes[index + 1]); // Move to next
          }
          _onOtpEntered();
        },
        onSubmitted: (_) => _onOtpEntered(),
        onEditingComplete: () {
          if (index > 0 && _controllers[index].text.isEmpty) {
            FocusScope.of(
              context,
            ).requestFocus(_focusNodes[index - 1]); // Move back
          }
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to verification_1.dart
            Navigator.pushReplacementNamed(context, '/verification_1');
          },
        ),
        title: const Text(
          "Enter OTP Code",
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
            const SizedBox(height: 30),
            const Text(
              "Enter the 6-digit verification code sent to your number",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOtpField(index)),
            ),

            const SizedBox(height: 20),

            // Resend OTP
            TextButton(
              onPressed: () {
                // Handle resend OTP logic
              },
              child: const Text(
                "Resend OTP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
