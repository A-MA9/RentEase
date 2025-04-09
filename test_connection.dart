import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final url = Uri.parse('http://10.0.2.2:8000/');
  
  try {
    print('Testing connection to backend server...');
    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Connection timed out');
      },
    );
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('✅ Connection successful!');
    } else {
      print('❌ Connection failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error connecting to backend server: $e');
  }
} 