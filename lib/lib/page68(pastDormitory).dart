import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../services/flutter_storage.dart';
import '../room_details.dart'; // Ensure this is the correct import

class PastDormsHistoryPage extends StatefulWidget {
  const PastDormsHistoryPage({Key? key}) : super(key: key);

  @override
  _PastDormsHistoryPageState createState() => _PastDormsHistoryPageState();
}

class _PastDormsHistoryPageState extends State<PastDormsHistoryPage> {
  List<dynamic> pastDorms = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchPastDorms();
  }

  Future<void> fetchPastDorms() async {
    try {
      final token = await SecureStorage.storage.read(key: 'access_token');

      if (token == null) throw Exception("Missing access token");

      final response = await http.get(
        Uri.parse('$baseUrl/bookings/display/seeker'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          pastDorms = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load past dorms");
      }
    } catch (e) {
      print("❌ Error fetching past dorms: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Past Dorms History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? const Center(child: Text("Failed to load past dorms."))
              : pastDorms.isEmpty
              ? const Center(child: Text("No past dorms found."))
              : ListView.builder(
                itemCount: pastDorms.length,
                itemBuilder: (context, index) {
                  final dorm = pastDorms[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => RoomDetailsPage(
                                      propertyId: dorm['property_id'],
                                    ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dorm['name'] ?? 'Unknown Dorm',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text("📍 ${dorm['location'] ?? 'Unknown'}"),
                              if (dorm['price'] != null)
                                Text("💰 ₹${dorm['price']}"),
                              const SizedBox(height: 6),
                              Text(
                                "📝 ${dorm['description'] ?? 'No description'}",
                              ),
                              if (dorm['created_at'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    "Created: ${formatDate(dorm['created_at'])}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
