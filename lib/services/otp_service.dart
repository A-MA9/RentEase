import 'dart:math';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpService {
  // EmailJS credentials
  static const String serviceId = 'service_n910zan';
  static const String templateId = 'template_q77fc9v';
  static const String publicKey = '-rssrvgAJxzUu8WeH';
  
  // Generate a 6-digit OTP
  static String generateOtp() {
    return randomNumeric(6);
  }
  
  // Send OTP via EmailJS REST API
  static Future<bool> sendOtp({
    required String email,
    required String name,
    required String otp,
  }) async {
    try {
      print('Sending OTP email to: $email');
      print('Template ID: $templateId');
      print('Service ID: $serviceId');
      
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final payload = {
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'to_email': email,
          'to_name': name,
          'otp': otp,
        },
      };
      
      print('Request payload: ${json.encode(payload)}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost:3000', // Add this line to handle CORS
        },
        body: json.encode(payload),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        // Store OTP in shared preferences for verification
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('otp_$email', otp);
        await prefs.setInt('otp_timestamp_$email', DateTime.now().millisecondsSinceEpoch);
        return true;
      } else {
        print('Failed to send email. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      print('Error sending OTP: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
  
  // Verify OTP
  static Future<bool> verifyOtp({
    required String email,
    required String enteredOtp,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedOtp = prefs.getString('otp_$email');
      final timestamp = prefs.getInt('otp_timestamp_$email');
      
      if (storedOtp == null || timestamp == null) {
        return false;
      }
      
      // Check if OTP is expired (10 minutes = 600000 milliseconds)
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime - timestamp > 600000) {
        // OTP expired
        await prefs.remove('otp_$email');
        await prefs.remove('otp_timestamp_$email');
        return false;
      }
      
      // Verify OTP
      if (storedOtp == enteredOtp) {
        // Clear OTP after successful verification
        await prefs.remove('otp_$email');
        await prefs.remove('otp_timestamp_$email');
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }
} 