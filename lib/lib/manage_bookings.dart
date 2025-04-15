import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../services/flutter_storage.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({Key? key}) : super(key: key);

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  List<dynamic> bookings = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final token = await SecureStorage.storage.read(key: 'access_token');

      if (token == null) throw Exception("Missing access token");

      final response = await http.get(
        Uri.parse('$baseUrl/bookings/display'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          bookings = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load bookings");
      }
    } catch (e) {
      print("❌ Error fetching bookings: $e");
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
          'View Bookings',
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
              ? const Center(child: Text("Failed to load bookings."))
              : bookings.isEmpty
              ? const Center(child: Text("No bookings found."))
              : ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index]['booking'];
                  final property = bookings[index]['property'];
                  final seekerName = bookings[index]['seeker_name'];

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property['title'] ?? 'Unknown Property',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text("📍 ${property['location']}"),
                            Text("💰 ₹${booking['total_price']}"),
                            Text("🧍 Booked by: $seekerName"),
                            const SizedBox(height: 6),
                            Text(
                              "🗓 ${formatDate(booking['start_date'])} → ${formatDate(booking['end_date'])}",
                            ),
                            Text("Status: ${booking['status']}"),
                            const SizedBox(height: 6),
                            Text(
                              "Created: ${formatDate(booking['created_at'])}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
