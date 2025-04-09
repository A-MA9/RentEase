import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart' as constants;

class BookingService {
  static const storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> createBooking({
    required String dormitoryName,
    required String seekerEmail,
    required String ownerEmail,
    required DateTime checkInDate,
    required double totalAmount,
  }) async {
    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = constants.baseUrl;
      print('🔹 Using baseUrl: $url'); // Debug log
      print('🔹 Creating booking with data:');
      print('  - Dormitory: $dormitoryName');
      print('  - Seeker Email: $seekerEmail');
      print('  - Owner Email: $ownerEmail');
      print('  - Check-in Date: ${checkInDate.toIso8601String().split('T')[0]}');
      print('  - Total Amount: $totalAmount');

      // Create request body
      final Map<String, dynamic> requestBody = {
        'dormitory_name': dormitoryName,
        'seeker_email': seekerEmail,
        'owner_email': ownerEmail,
        'check_in_date': checkInDate.toIso8601String().split('T')[0],
        'total_amount': totalAmount.toString(), // Send as string for DynamoDB compatibility
      };
      
      print('🔹 Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$url/bookings/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timed out. Please check your internet connection and try again.');
        },
      );

      print('🔹 Response status: ${response.statusCode}'); // Debug log
      print('🔹 Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create booking: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error creating booking: $e');
      rethrow;
    }
  }
}
