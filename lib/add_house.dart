import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

final baseUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';
final FlutterSecureStorage storage = const FlutterSecureStorage();

class AddHouse extends StatefulWidget {
  final int ownerId;

  const AddHouse({Key? key, required this.ownerId}) : super(key: key);

  @override
  _AddHouseState createState() => _AddHouseState();
}

class _AddHouseState extends State<AddHouse> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String location = '';
  double price = 0.0;

  Future<void> addHouse() async {
    final url = Uri.parse('$baseUrl/properties');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'location': location,
        'price': price,
        'owner_id': widget.ownerId,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context); // Go back to the house list
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add house')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add House')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'House Name'),
                validator:
                    (value) => value!.isEmpty ? 'Enter house name' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Enter location' : null,
                onSaved: (value) => location = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter price' : null,
                onSaved: (value) => price = double.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    addHouse();
                  }
                },
                child: Text('Add House'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
