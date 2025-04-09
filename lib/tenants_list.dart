import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_page.dart';
import 'services/flutter_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TenantsListPage extends StatefulWidget {
  final String propertyId;

  const TenantsListPage({Key? key, required this.propertyId}) : super(key: key);

  @override
  _TenantsListPageState createState() => _TenantsListPageState();
}

class _TenantsListPageState extends State<TenantsListPage> {
  List<dynamic> tenants = [];
  bool isLoading = true;
  String? token;

  final baseUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchTenants();
  }

  Future<void> _loadTokenAndFetchTenants() async {
    final storedToken = await SecureStorage.storage.read(key: "access_token");
    if (storedToken != null) {
      setState(() => token = storedToken);
      fetchTenants();
    }
  }

  Future<void> fetchTenants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/seekers/${widget.propertyId}'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          tenants = data;
          isLoading = false;
        });
      } else {
        print("Failed to load tenants: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching tenants: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ask Previous Tenants')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : tenants.isEmpty
              ? Center(child: Text("No previous tenants found."))
              : ListView.builder(
                itemCount: tenants.length,
                itemBuilder: (context, index) {
                  final tenant = tenants[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        (tenant['seeker_name']?.isNotEmpty ?? false)
                            ? tenant['seeker_name'][0]
                            : '?',
                      ),
                    ),
                    title: Text(tenant['seeker_name'] ?? 'Unknown Tenant'),
                    subtitle: Text("Tap to chat"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ChatPage(
                                receiverId: tenant['seeker_id'],
                                receiverName:
                                    tenant['seeker_name'] ?? 'Unknown',
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
