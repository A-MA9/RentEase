import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class AddressToLatLng extends StatefulWidget {
  @override
  _AddressToLatLngState createState() => _AddressToLatLngState();
}

class _AddressToLatLngState extends State<AddressToLatLng> {
  String address =
      "1600 Amphitheatre Parkway, Mountain View, CA"; // Example Address
  double? latitude;
  double? longitude;

  Future<void> getLatLong() async {
    try {
      List<Location> locations = await locationFromAddress(address);
      setState(() {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getLatLong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Address to Coordinates")),
      body: Center(
        child:
            latitude == null || longitude == null
                ? CircularProgressIndicator()
                : Text("Latitude: $latitude, Longitude: $longitude"),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: AddressToLatLng()));
}
