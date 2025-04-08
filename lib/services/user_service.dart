import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static const storage = FlutterSecureStorage();
  
  // Get the API base URL based on platform
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    return 'http://10.0.2.2:8000';
  }
  
  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await storage.read(key: 'access_token');
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading profile: $e');
      rethrow;
    }
  }
  
  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile({
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      final token = await storage.read(key: 'access_token');
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final Map<String, dynamic> updateData = {};
      if (fullName != null) updateData['full_name'] = fullName;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;

      final response = await http.put(
        Uri.parse('$_baseUrl/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        final updatedProfile = json.decode(response.body);
        
        // Also update the locally stored user information if needed
        if (fullName != null) {
          await storage.write(key: 'user_name', value: fullName);
        }
        if (phoneNumber != null) {
          await storage.write(key: 'user_phone', value: phoneNumber);
        }
        
        return updatedProfile;
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
  
  // Get locally stored user data
  static Future<Map<String, String?>> getLocalUserData() async {
    final userId = await storage.read(key: 'user_id');
    final userName = await storage.read(key: 'user_name');
    final userEmail = await storage.read(key: 'user_email');
    final userPhone = await storage.read(key: 'user_phone');
    final userType = await storage.read(key: 'user_type');
    
    return {
      'id': userId,
      'full_name': userName,
      'email': userEmail,
      'phone_number': userPhone,
      'user_type': userType,
    };
  }
} 