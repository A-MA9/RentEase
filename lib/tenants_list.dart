import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'constants.dart';

class TenantsListPage extends StatefulWidget {
  final dynamic propertyId;

  const TenantsListPage({super.key, required this.propertyId});

  @override
  _TenantsListPageState createState() => _TenantsListPageState();
}

class _TenantsListPageState extends State<TenantsListPage> {
  List<dynamic> tenants = [];
  bool isLoading = true;
  final storage = const FlutterSecureStorage();
  
  @override
  void initState() {
    super.initState();
    fetchTenants();
  }

  Future<void> fetchTenants() async {
    try {
      final token = await storage.read(key: "access_token");
      if (token == null) {
        setState(() => isLoading = false);
        return;
      }
      
      final response = await http.get(
        Uri.parse('${baseUrl}/bookings/seekers/${widget.propertyId}'),
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
