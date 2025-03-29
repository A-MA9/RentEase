import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'search_page.dart'; // Import the search page
import 'home_page.dart'; // Import the home page
import 'lib/page66(profile).dart'; // Import the profile page

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _locationPermissionGranted = false;
  List<dynamic> _nearbyRentals = [];
  bool _isLoading = false;
  String? _error;
  int _selectedIndex = 0; // Add this to track selected bottom nav item

  // Get the base URL based on platform
  String get _baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    return 'http://10.0.2.2:8000';
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  void _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      setState(() {
        _locationPermissionGranted = true;
      });
      _loadNearbyRentals();
    }
  }

  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      setState(() {
        _locationPermissionGranted = true;
      });
      _loadNearbyRentals();
    }
  }

  void _loadNearbyRentals() async {
    if (!_locationPermissionGranted) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('Fetching properties from: ${_baseUrl}/properties/nearby');

      final response = await http
          .get(
            Uri.parse('${_baseUrl}/properties/nearby'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        print('Decoded data: $decodedData');
        setState(() {
          _nearbyRentals = decodedData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load properties: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error loading properties: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _error = 'Error loading properties. Please try again.';
        _isLoading = false;
      });
    }
  }

  Widget _buildPropertyList() {
    if (!_locationPermissionGranted) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                "Location permission required",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please enable location to see rentals near you",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _requestLocationPermission,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text(
                  "Enable Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
          ),
        ),
      );
    }

    if (_error != null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadNearbyRentals,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_nearbyRentals.isEmpty) {
      return const Expanded(
        child: Center(child: Text('No properties available in your area.')),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _nearbyRentals.length,
        itemBuilder: (context, index) {
          final rental = _nearbyRentals[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: const Icon(Icons.home, color: Colors.brown),
              title: Text(rental['location']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rental['title']),
                  Text(rental['property_type']),
                  Text('₹${rental['price_per_month']} per month'),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  // Handle bottom navigation bar tap PROFILE PAGE
  void _onItemTapped(int index) {
    if (index == 4) {
      // Person icon index (profile)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: const Text(
          "Find Your Rental",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for rentals...',
                    prefixIcon: Icon(Icons.search, color: Colors.brown),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.my_location, color: Colors.brown),
              title: const Text("My Current Location"),
              onTap: _requestLocationPermission,
            ),
            const SizedBox(height: 10),
            const Text(
              "Popular Locations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: [
                GestureDetector(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      ),
                  child: const Chip(label: Text("Jaipur")),
                ),
                const Chip(label: Text("Gandhi Market")),
                const Chip(label: Text("Bagru")),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Popular Rentals Near You",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            _buildPropertyList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
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
