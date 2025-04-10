import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/property_model.dart';
import '../constants.dart';

class PropertyService {
  static const storage = FlutterSecureStorage();
  
  // Create a new property
  static Future<Map<String, dynamic>> createProperty({
    required String title,
    required String propertyType,
    required String description,
    required String location,
    required double pricePerMonth,
    required int minStayMonths,
    required List<String> imageUrls,
    List<String>? panoramicUrls,
    double? sizeSqft,
    required Map<String, bool> amenities,
    required String gender,
    required int roomsAvailable,
  }) async {
    try {
      final token = await storage.read(key: 'access_token');
      final userId = await storage.read(key: 'user_id');
      
      if (token == null || userId == null) {
        throw Exception('Authentication token or user ID not found');
      }

      print('🔹 Using token: $token'); // Debug log
      print('🔹 User ID: $userId'); // Debug log

      final response = await http.post(
        Uri.parse('${baseUrl}/properties/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'owner_id': userId,
          'title': title,
          'property_type': propertyType,
          'description': description,
          'location': location,
          'price_per_month': pricePerMonth,
          'min_stay_months': minStayMonths,
          'image_urls': imageUrls,
          'panoramic_urls': panoramicUrls ?? [],
          'gender': gender,
          'rooms_available': roomsAvailable,
          'size_sqft': sizeSqft,
          'tv': amenities['tv'] ?? false,
          'fan': amenities['fan'] ?? false,
          'ac': amenities['ac'] ?? false,
          'chair': amenities['chair'] ?? false,
          'ventilation': amenities['ventilation'] ?? false,
          'ups': amenities['ups'] ?? false,
          'sofa': amenities['sofa'] ?? false,
          'lamp': amenities['lamp'] ?? false,
          'bath': amenities['bath'] ?? 1,
          'is_available': true,
        }),
      );

      print('🔹 Response status: ${response.statusCode}'); // Debug log
      print('🔹 Response body: ${response.body}'); // Debug log

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create property: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating property: $e');
      rethrow;
    }
  }

  // Get all properties for the logged-in owner
  static Future<List<Property>> getOwnerProperties() async {
    try {
      final token = await storage.read(key: 'access_token');
      final userId = await storage.read(key: 'user_id');
      
      if (token == null || userId == null) {
        throw Exception('Authentication token or user ID not found');
      }

      final response = await http.get(
        Uri.parse('${baseUrl}/properties?owner_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Property.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load properties');
      }
    } catch (e) {
      print('Error loading properties: $e');
      rethrow;
    }
  }
  
  // Get nearby properties for seekers
  static Future<List<Property>> getNearbyProperties() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/properties/nearby'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Property.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nearby properties');
      }
    } catch (e) {
      print('Error loading nearby properties: $e');
      rethrow;
    }
  }
} 