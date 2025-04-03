import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'add_house.dart';
import 'dormitory_details.dart';

final baseUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';
final FlutterSecureStorage storage = const FlutterSecureStorage();

class OwnerHouses extends StatefulWidget {
  const OwnerHouses({Key? key}) : super(key: key);

  @override
  _OwnerHousesState createState() => _OwnerHousesState();
}

class _OwnerHousesState extends State<OwnerHouses> {
  List houses = [];
  String? ownerId;

  @override
  void initState() {
    super.initState();
    _fetchOwnerId();
  }

  Future<void> _fetchOwnerId() async {
    String? storedOwnerId = await storage.read(key: "user_id");
    if (storedOwnerId != null) {
      setState(() {
        ownerId = storedOwnerId;
      });
      _fetchHouses();
    }
  }

  Future<void> _fetchHouses() async {
    // print(ownerId);

    if (ownerId == null) return;

    final url = Uri.parse('$baseUrl/properties?owner_id=$ownerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        houses = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load houses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Rentals')),
      body:
          ownerId == null
              ? Center(child: CircularProgressIndicator())
              : houses.isEmpty
              ? Center(child: Text("No houses added yet."))
              : ListView.builder(
                itemCount: houses.length,
                itemBuilder: (context, index) {
                  final house = houses[index];
                  return Card(
                    child: ListTile(
                      title: Text(house['title']),
                      subtitle: Text(house['location']),
                      trailing: Text('\$${house['price_per_month']}'),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (ownerId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DormitoryDetailsPage()),
            ).then((_) => _fetchHouses()); // Refresh list after adding
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
