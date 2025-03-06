import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'property_type.dart';
import 'services/otp_service.dart';

class Verification2Screen extends StatefulWidget {
  final int userType;
  final String email;

  const Verification2Screen({
    Key? key, 
    required this.userType,
    required this.email,
  }) : super(key: key);

  @override
  State<Verification2Screen> createState() => _Verification2ScreenState();
}

class _Verification2ScreenState extends State<Verification2Screen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  bool _isVerifying = false;
  String? _errorMessage;

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

  Future<void> _verifyOtp() async {
    String otpCode = _controllers.map((e) => e.text).join();
    
    if (otpCode.length != 6) {
      setState(() {
        _errorMessage = 'Please enter all 6 digits';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final isValid = await OtpService.verifyOtp(
        email: widget.email,
        enteredOtp: otpCode,
      );

      if (isValid) {
        // Navigate based on user type
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
      } else {
        setState(() {
          _errorMessage = 'Invalid or expired OTP. Please try again.';
          _isVerifying = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isVerifying = false;
      });
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
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]); // Move to next
          }
          if (_controllers.every((controller) => controller.text.isNotEmpty)) {
            _verifyOtp();
          }
        },
        onEditingComplete: () {
          if (index > 0 && _controllers[index].text.isEmpty) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]); // Move back
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
            Navigator.pop(context);
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
            Text(
              "Enter the 6-digit verification code sent to ${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOtpField(index)),
            ),

            const SizedBox(height: 20),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            if (_isVerifying)
              const CircularProgressIndicator(color: Colors.brown)
            else
              ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(color: Colors.white),
                ),
              ),

            const SizedBox(height: 20),

            // Resend OTP
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
