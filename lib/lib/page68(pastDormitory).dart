import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../services/flutter_storage.dart';
import '../room_details.dart';
import '../utils/loading_animations.dart';
import 'dart:io';

class PastDormsHistoryPage extends StatefulWidget {
  const PastDormsHistoryPage({Key? key}) : super(key: key);

  @override
  _PastDormsHistoryPageState createState() => _PastDormsHistoryPageState();
}

class _PastDormsHistoryPageState extends State<PastDormsHistoryPage> {
  List<dynamic> pastDorms = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";
  int retryCount = 0;
  final int maxRetries = 3;
  bool isRetrying = false;

  @override
  void initState() {
    super.initState();
    // Wake up server first, then fetch data
    _wakeUpServerAndFetchData();
  }

  Future<void> _wakeUpServerAndFetchData() async {
    await _pingServer();
    await fetchPastDorms();
  }

  Future<void> _pingServer() async {
    try {
      // Try to ping a simple endpoint to wake up the Render server
      print("🔹 Sending wake-up ping to server...");
      final response = await http.get(
        Uri.parse('$baseUrl/'),
      ).timeout(const Duration(seconds: 10));
      
      print("🔹 Server wake-up ping response: ${response.statusCode}");
    } catch (e) {
      print("⚠️ Server wake-up ping failed: $e");
      // Continue anyway, the main request will handle errors
    }
  }

  Future<void> _retryWithDelay() async {
    if (retryCount < maxRetries && !isRetrying) {
      isRetrying = true;
      retryCount++;
      
      // Show retrying message
      setState(() {
        errorMessage = "Retrying... ($retryCount/$maxRetries)";
      });
      
      // Exponential backoff: 2s, 4s, 8s
      final delay = Duration(seconds: 2 * retryCount);
      print("🔄 Retrying in ${delay.inSeconds} seconds (attempt $retryCount of $maxRetries)");
      
      await Future.delayed(delay);
      isRetrying = false;
      await fetchPastDorms();
    }
  }

  Future<void> fetchPastDorms() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
        errorMessage = "";
      });
      
      // Get access token
      final token = await SecureStorage.storage.read(key: 'access_token');
      
      if (token == null) {
        throw Exception("Missing access token");
      }

      // Print token info for debugging (don't expose the full token)
      final tokenStart = token.substring(0, token.length > 10 ? 10 : token.length);
      print("🔑 Using token: ${tokenStart}... (${token.length} chars)");

      // Build request with timeout
      final url = Uri.parse('$baseUrl/bookings/display/seeker');
      
      print("📡 Fetching past dorms from: $url");
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Connection': 'keep-alive',
        },
      ).timeout(
        const Duration(seconds: 30), // Longer timeout for slow Render spin-up
        onTimeout: () {
          print("⏱️ Request timed out after 30 seconds");
          return http.Response('{"error":"Request timed out - server may be spinning up"}', 408);
        },
      );

      // Debug response
      print("🔹 Response status: ${response.statusCode}");
      
      if (response.body.isNotEmpty) {
        final previewLength = response.body.length > 100 ? 100 : response.body.length;
        print("🔹 Response preview: ${response.body.substring(0, previewLength)}...");
      } else {
        print("⚠️ Empty response body");
      }

      if (response.statusCode == 200) {
        // Success case
        try {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            pastDorms = data;
            isLoading = false;
            retryCount = 0; // Reset retry counter on success
          });
        } catch (e) {
          print("❌ JSON decode error: $e");
          throw Exception("Server returned invalid data format");
        }
      } else if (response.statusCode == 401) {
        // Unauthorized - token might be expired
        await SecureStorage.storage.delete(key: 'access_token');
        throw Exception("Session expired. Please login again.");
      } else if (response.statusCode == 404) {
        // Endpoint not found - might be a new API structure
        throw Exception("API endpoint not found. The server may have been updated.");
      } else if (response.statusCode == 408) {
        // Timeout - likely server is spinning up
        throw Exception("Server is taking longer to respond. This might be because it's starting up.");
      } else if (response.statusCode >= 500) {
        // Server error - retry
        throw Exception("Server error (${response.statusCode}). The server might be starting up.");
      } else {
        // Other errors
        throw Exception("Failed to load past dorms. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching past dorms: $e");
      
      // Handle different types of errors
      if (e is SocketException) {
        setState(() {
          errorMessage = "Network connection error. Please check your internet connection.";
        });
        _retryWithDelay();
      } else if (e.toString().contains("timed out")) {
        setState(() {
          errorMessage = "Request timed out. The server may be starting up. Please wait or try again.";
        });
        _retryWithDelay();
      } else {
        setState(() {
          errorMessage = e.toString().contains("Exception:") 
              ? e.toString().split("Exception:")[1].trim() 
              : "Failed to load past dorms. Please try again.";
        });
        
        // For other errors, also retry
        _retryWithDelay();
      }
      
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
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimations.dataLoading(),
                  const SizedBox(height: 20),
                  Text(
                    retryCount > 0
                        ? "Loading... (attempt $retryCount)"
                        : "Loading past bookings...",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (retryCount > 0)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "This may take longer as the server is starting up.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            )
          : hasError
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: fetchPastDorms,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                          ),
                          child: const Text(
                            "Try Again",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : pastDorms.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No past bookings found",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Book a dormitory to see your history here",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: pastDorms.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final dorm = pastDorms[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RoomDetailsPage(
                                      propertyId: dorm['property_id'],
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
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
                                    const SizedBox(height: 8),
                                    Text("📍 ${dorm['location'] ?? 'Unknown'}"),
                                    if (dorm['price'] != null)
                                      Text("💰 ₹${dorm['price']}"),
                                    const SizedBox(height: 8),
                                    Text(
                                      "📝 ${dorm['description'] ?? 'No description'}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (dorm['created_at'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
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
