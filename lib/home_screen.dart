import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _locationPermissionGranted = false;
  List<Map<String, String>> _nearbyRentals = [];

  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      setState(() {
        _locationPermissionGranted = true;
        _loadNearbyRentals();
      });
    }
  }

  void _loadNearbyRentals() {
    _nearbyRentals = [
      {"name": "Cozy Studio Apartment", "location": "Downtown"},
      {"name": "Luxury 2BHK Flat", "location": "City Center"},
      {"name": "Budget PG", "location": "Near University"},
      {"name": "Spacious Villa", "location": "Suburban Area"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for rentals...',
              prefixIcon: Icon(Icons.search, color: Colors.brown),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Location Option
            ListTile(
              leading: Icon(Icons.my_location, color: Colors.brown),
              title: Text("My Current Location"),
              onTap: _requestLocationPermission,
            ),
            SizedBox(height: 10),

            // Popular Searches
            Text(
              "Popular Locations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: [
                Chip(label: Text("Masala Chowk")),
                Chip(label: Text("Gandhi Market")),
                Chip(label: Text("Bagru")),
              ],
            ),
            SizedBox(height: 20),

            // Popular Rentals Near You
            Text(
              "Popular Rentals Near You",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),

            _locationPermissionGranted
                ? Expanded(
                  child: ListView.builder(
                    itemCount: _nearbyRentals.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.home, color: Colors.brown),
                        title: Text(_nearbyRentals[index]["name"]!),
                        subtitle: Text(_nearbyRentals[index]["location"]!),
                      );
                    },
                  ),
                )
                : Column(
                  children: [
                    Text(
                      "Turn on location to see rentals near you.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
