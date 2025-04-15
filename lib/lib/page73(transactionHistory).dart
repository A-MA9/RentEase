import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../services/flutter_storage.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<dynamic> transactions = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final token = await SecureStorage.storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('$baseUrl/bookings/display'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          transactions = data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch transactions.");
      }
    } catch (e) {
      print("❌ Error: $e");
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? const Center(child: Text("Failed to load transactions."))
              : transactions.isEmpty
              ? const Center(child: Text("No completed transactions found."))
              : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  final booking = t['booking'];
                  final property = t['property'];
                  final seekerName = t['seeker_name'];
                  final ownerName = t['owner_name'];

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
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
                              property['title'] ?? "Unknown Property",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("Paid by: $seekerName"),
                            Text("Amount: ₹${booking['total_price']}"),
                            Text("Date: ${formatDate(booking['created_at'])}"),
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
