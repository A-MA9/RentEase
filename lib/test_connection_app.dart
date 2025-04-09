import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart' as constants;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connection Test',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const ConnectionTestPage(),
    );
  }
}

class ConnectionTestPage extends StatefulWidget {
  const ConnectionTestPage({Key? key}) : super(key: key);

  @override
  _ConnectionTestPageState createState() => _ConnectionTestPageState();
}

class _ConnectionTestPageState extends State<ConnectionTestPage> {
  String _status = 'Not tested';
  String _responseBody = '';
  bool _isLoading = false;
  final storage = const FlutterSecureStorage();

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing...';
      _responseBody = '';
    });

    try {
      final url = constants.baseUrl;
      print('Testing connection to backend server at: $url');
      
      // First, test a simple GET request
      final getResponse = await http.get(Uri.parse('$url/properties')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timed out');
        },
      );
      
      print('GET Response status: ${getResponse.statusCode}');
      print('GET Response body: ${getResponse.body}');
      
      // Then, test the booking endpoint
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        setState(() {
          _isLoading = false;
          _status = '❌ No authentication token found. Please log in first.';
          _responseBody = '';
        });
        return;
      }
      
      print('Using token: $token');
      
      final bookingData = {
        'dormitory_name': 'Test Dormitory',
        'seeker_email': 'test@example.com',
        'owner_email': 'owner@example.com',
        'check_in_date': DateTime.now().toIso8601String().split('T')[0],
        'total_amount': 1000.0,
      };
      
      print('Sending booking data: $bookingData');
      
      final postResponse = await http.post(
        Uri.parse('$url/bookings/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(bookingData),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timed out');
        },
      );
      
      print('POST Response status: ${postResponse.statusCode}');
      print('POST Response body: ${postResponse.body}');
      
      setState(() {
        _isLoading = false;
        if (getResponse.statusCode == 200) {
          _status = '✅ GET request successful!';
        } else {
          _status = '❌ GET request failed with status code: ${getResponse.statusCode}';
        }
        _responseBody = 'GET Response: ${getResponse.body}\n\nPOST Response: ${postResponse.body}';
      });
    } catch (e) {
      print('❌ Error connecting to backend server: $e');
      setState(() {
        _isLoading = false;
        _status = '❌ Error: $e';
        _responseBody = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Connection Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Backend URL: ${constants.baseUrl}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _testConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Test Connection',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                _status,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (_responseBody.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Response:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _responseBody,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 