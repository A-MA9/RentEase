import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../room_details.dart'; // Import your room details page
import '../constants.dart'; // Import constants.dart for the base URL

class PastDormsHistoryPage extends StatefulWidget {
  @override
  _PastDormsHistoryPageState createState() => _PastDormsHistoryPageState();
}

class _PastDormsHistoryPageState extends State<PastDormsHistoryPage> {
  List<dynamic> pastDorms = [];

  @override
  void initState() {
    super.initState();
    fetchPastDorms();
  }

  // Fetch past dorms data from the backend
  Future<void> fetchPastDorms() async {
    final response = await http.get(Uri.parse('${baseUrl}/bookings/display'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        pastDorms = data;
      });
    } else {
      throw Exception('Failed to load past dorms');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Past Dorms History")),
      body:
          pastDorms.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: pastDorms.length,
                itemBuilder: (context, index) {
                  final dorm = pastDorms[index]['property'];
                  return ListTile(
                    leading: Image.network(
                      dorm['image'],
                    ), // Image URL from backend
                    title: Text(dorm['name']),
                    subtitle: Text(dorm['location']),
                    trailing: Text("\$${dorm['price']}"),
                    onTap: () {
                      // Pass property_id to RoomDetailsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  RoomDetailsPage(propertyId: dorm['id']),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
