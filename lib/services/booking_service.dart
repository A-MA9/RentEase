import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';

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

      print('🔹 Using token: $token'); // Debug log

      // final baseUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';
      final response = await http.post(
        Uri.parse('$baseUrl/bookings/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'dormitory_name': dormitoryName,
          'seeker_email': seekerEmail,
          'owner_email': ownerEmail,
          'check_in_date': checkInDate.toIso8601String().split('T')[0],
          'total_amount': totalAmount,
        }),
      );

      print('🔹 Response status: ${response.statusCode}'); // Debug log
      print('🔹 Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create booking: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }
}
