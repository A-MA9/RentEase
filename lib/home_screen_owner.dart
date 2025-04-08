// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'search_page.dart';
// import 'home_page_owner.dart';
// import 'lib/page66(NoLoginProfile).dart';
// import 'profile_router.dart';
// import 'chat_list.dart';
// import 'owner_houses.dart';

// class HomeScreenOwner extends StatefulWidget {
//   const HomeScreenOwner({super.key});

//   @override
//   _HomeScreenOwnerState createState() => _HomeScreenOwnerState();
// }

// class _HomeScreenOwnerState extends State<HomeScreenOwner> {
//   bool _locationPermissionGranted = false;
//   List<dynamic> _nearbyRentals = [];
//   bool _isLoading = false;
//   String? _error;
//   int _selectedIndex = 2; // Default to home

//   String get baseUrl {
//     if (kIsWeb) {
//       return 'http://127.0.0.1:8000';
//     }
//     return 'http://10.0.2.2:8000';
//   }

//   @override
//   void initState() {
//     super.initState();
//     _checkLocationPermission();
//   }

//   void _checkLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse) {
//       setState(() {
//         _locationPermissionGranted = true;
//       });
//       _loadNearbyRentals();
//     }
//   }

//   void _requestLocationPermission() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse) {
//       setState(() {
//         _locationPermissionGranted = true;
//       });
//       _loadNearbyRentals();
//     }
//   }

//   void _loadNearbyRentals() async {
//     if (!_locationPermissionGranted) return;

//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final response = await http
//           .get(
//             Uri.parse('${baseUrl}/properties/nearby'),
//             headers: {
//               'Accept': 'application/json',
//               'Content-Type': 'application/json',
//             },
//           )
//           .timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final decodedData = json.decode(response.body);
//         setState(() {
//           _nearbyRentals = decodedData;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _error = 'Failed to load properties: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Error loading properties. Please try again.';
//         _isLoading = false;
//       });
//     }
//   }

//   Widget _buildPropertyList() {
//     if (!_locationPermissionGranted) {
//       return Expanded(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.location_off, size: 64, color: Colors.grey),
//               const SizedBox(height: 16),
//               const Text(
//                 "Location permission required",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 "Please enable location to see rentals near you",
//                 style: TextStyle(color: Colors.grey),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _requestLocationPermission,
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
//                 child: const Text(
//                   "Enable Location",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_isLoading) {
//       return const Expanded(
//         child: Center(
//           child: CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
//           ),
//         ),
//       );
//     }

//     if (_error != null) {
//       return Expanded(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(_error!, style: const TextStyle(color: Colors.red)),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _loadNearbyRentals,
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_nearbyRentals.isEmpty) {
//       return const Expanded(
//         child: Center(child: Text('No properties available in your area.')),
//       );
//     }

//     return Expanded(
//       child: ListView.builder(
//         itemCount: _nearbyRentals.length,
//         itemBuilder: (context, index) {
//           final rental = _nearbyRentals[index];
//           return Card(
//             margin: const EdgeInsets.only(bottom: 8.0),
//             child: ListTile(
//               leading: const Icon(Icons.home, color: Colors.brown),
//               title: Text(rental['location']),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(rental['title']),
//                   Text(rental['property_type']),
//                   Text('₹${rental['price_per_month']} per month'),
//                 ],
//               ),
//               isThreeLine: true,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     if (index == 4) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ProfileRouter()),
//       );
//     } else if (index == 0) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreenOwner()),
//       );
//     } else if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => OwnerHouses()),
//       );
//     } else if (index == 3) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ChatListScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HomePageOwner()),
//             );
//           },
//         ),
//         title: const Text(
//           "Find Your Rental",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: const TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search for rentals...',
//                     prefixIcon: Icon(Icons.search, color: Colors.brown),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 12,
//                       horizontal: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.my_location, color: Colors.brown),
//               title: const Text("My Current Location"),
//               onTap: _requestLocationPermission,
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Popular Locations",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             Wrap(
//               spacing: 8.0,
//               children: [
//                 GestureDetector(
//                   onTap:
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => SearchPage()),
//                       ),
//                   child: const Chip(label: Text("Jaipur")),
//                 ),
//                 const Chip(label: Text("Gandhi Market")),
//                 const Chip(label: Text("Bagru")),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Popular Rentals Near You",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             _buildPropertyList(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }

// class BottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;

//   const BottomNavBar({required this.selectedIndex, required this.onItemTapped});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, -3),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         child: BottomNavigationBar(
//           items: [
//             const BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/building_brown.png',
//                 width: 24,
//                 height: 24,
//               ),
//               label: "My Properties",
//             ),
//             const BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//             const BottomNavigationBarItem(icon: Icon(Icons.message), label: ""),
//             const BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
//           ],
//           currentIndex: selectedIndex,
//           onTap: onItemTapped,
//           selectedItemColor: Colors.brown,
//           unselectedItemColor: Colors.black54,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//         ),
//       ),
//     );
//   }
// }

// HomeScreenOwner.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
// Import the NEW SearchPage (make sure the path is correct)
import 'search_page.dart';
import 'home_page_owner.dart';
import 'lib/page66(NoLoginProfile).dart'; // Check this import path
import 'profile_router.dart';
import 'chat_list.dart';
import 'owner_houses.dart';
import 'constants.dart'; // Ensure you have this file for constants

class HomeScreenOwner extends StatefulWidget {
  const HomeScreenOwner({super.key});

  @override
  _HomeScreenOwnerState createState() => _HomeScreenOwnerState();
}

class _HomeScreenOwnerState extends State<HomeScreenOwner> {
  bool _locationPermissionGranted = false;
  List<dynamic> _nearbyRentals = []; // Renamed from _displayedRentals
  bool _isLoading = true; // Start loading initially for nearby
  String? _error;
  int _selectedIndex = 2; // Default to home (or adjust as needed)

  final TextEditingController _searchController = TextEditingController();
  // Removed _debounce and _isSearching

  // String get baseUrl {
  //   if (kIsWeb) {
  //     return 'http://127.0.0.1:8000';
  //   }
  //   return 'http://10.0.2.2:8000'; // Ensure correct IP
  // }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission(); // Load nearby initially if permission exists
    // Removed search controller listener for debouncing
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose controller
    super.dispose();
  }

  // --- Location Permission and Nearby Rentals Logic (Mostly Unchanged) ---

  void _checkLocationPermission() async {
    setState(() {
      _isLoading = true;
      _error = null;
    }); // Start loading
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        setState(() {
          _locationPermissionGranted = true;
        });
        _loadNearbyRentals();
      } else {
        setState(() {
          _locationPermissionGranted = false;
          _isLoading = false; // Stop loading if no permission
          // Optionally show some default popular rentals instead of location prompt
          // _loadDefaultRentals();
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error checking location permission: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  void _requestLocationPermission() async {
    _searchController.clear(); // Clear search if requesting location
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        setState(() {
          _locationPermissionGranted = true;
        });
        _loadNearbyRentals();
      } else {
        setState(() {
          _locationPermissionGranted = false;
          _error = "Location permission denied.";
          _isLoading = false;
          _nearbyRentals = []; // Clear list if permission denied
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error requesting location permission: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  void _loadNearbyRentals() async {
    if (!_locationPermissionGranted) {
      setState(() {
        _isLoading = false;
      }); // Stop loading if no permission
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http
          .get(
            Uri.parse(
              '${baseUrl}/properties/nearby',
            ), // Assuming this endpoint exists
            headers: {
              'Accept': 'application/json',
              // Add Auth header if needed
            },
          )
          .timeout(const Duration(seconds: 15));

      if (mounted) {
        // Check if the widget is still in the tree
        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          setState(() {
            _nearbyRentals = decodedData;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Failed to load nearby properties: ${response.statusCode}';
            _isLoading = false;
            _nearbyRentals = []; // Clear list on error
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading nearby properties: ${e.toString()}';
          _isLoading = false;
          _nearbyRentals = []; // Clear list on error
        });
      }
    }
  }

  // --- Removed _searchRentals function ---

  // --- Modified _buildPropertyList to only show nearby ---
  Widget _buildPropertyList() {
    // 1. Handle Location Permission Requirement
    if (!_locationPermissionGranted) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                "Location needed for nearby rentals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Enable location to see rentals near you or search by location above.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
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

    // 2. Handle Loading State
    if (_isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
          ),
        ),
      );
    }

    // 3. Handle Error State
    if (_error != null && _nearbyRentals.isEmpty) {
      // Show error only if no data
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadNearbyRentals, // Retry loading nearby
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 4. Handle No Results State
    if (_nearbyRentals.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No properties found nearby.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // 5. Display the List
    return Expanded(
      child: ListView.builder(
        itemCount: _nearbyRentals.length,
        itemBuilder: (context, index) {
          final rental = _nearbyRentals[index];
          final title = rental['title'] ?? 'No Title';
          final location = rental['location'] ?? 'Unknown Location';
          final propertyType = rental['property_type'] ?? 'N/A';
          final price =
              rental['price_per_month'] != null
                  ? '₹${rental['price_per_month']} per month'
                  : 'Price not available';

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
            elevation: 2,
            child: ListTile(
              leading: const Icon(
                Icons.home_work_outlined,
                color: Colors.brown,
              ),
              title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location),
                  SizedBox(height: 2),
                  Text(propertyType, style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 2),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                print('Tapped on nearby property: ${rental['id']}');
                // TODO: Navigate to Property Details Screen
                // Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailScreen(propertyId: rental['id'])));
              },
            ),
          );
        },
      ),
    );
  }

  // --- Navigation Logic (Mostly Unchanged, ensure index 2 logic is correct) ---
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // Avoid reloading the same page

    // Update the selected index visually
    setState(() {
      _selectedIndex = index;
    });

    // Use Navigator.pushReplacement to avoid building up the stack infinitely
    switch (index) {
      case 0: // Search Icon - Navigate to SearchPage
        final query = _searchController.text.trim();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(initialQuery: query),
          ), // Pass initial query
        );
        // Reset index visually back to home if needed after push
        // Future.delayed(Duration(milliseconds: 100), () => setState(() => _selectedIndex = 2));
        break;
      case 1: // My Properties
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OwnerHouses()),
        );
        break;
      case 2: // Home (This screen itself)
        // If already here, do nothing or maybe refresh nearby rentals
        if (!_isLoading) {
          // Avoid refreshing if already loading
          _checkLocationPermission(); // Refresh location/nearby
        }
        break;
      case 3: // Messages
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatListScreen()),
        );
        break;
      case 4: // Profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileRouter()),
        );
        break;
    }
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              // Go back to main owner dashboard
              context,
              MaterialPageRoute(builder: (context) => HomePageOwner()),
            );
          },
        ),
        title: const Text(
          // Static Title
          "Find Rentals",
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
            // --- Search Bar ---
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                        'Search by location and press enter...', // Updated hint
                    prefixIcon: Icon(Icons.search, color: Colors.brown),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                  ),
                  // *** Trigger navigation on submission ***
                  onSubmitted: (String query) {
                    final trimmedQuery = query.trim();
                    if (trimmedQuery.isNotEmpty) {
                      print(
                        "Navigating to SearchPage with query: $trimmedQuery",
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SearchPage(
                                initialQuery: trimmedQuery,
                              ), // Pass the query
                        ),
                      );
                    }
                  },
                  textInputAction:
                      TextInputAction.search, // Show search icon on keyboard
                ),
              ),
            ),

            // --- Current Location & Popular (Always visible now) ---
            ListTile(
              leading: const Icon(Icons.my_location, color: Colors.brown),
              title: const Text("Use My Current Location"),
              subtitle: Text(
                _locationPermissionGranted
                    ? "Showing nearby rentals below"
                    : "Tap to enable location",
              ),
              onTap: _requestLocationPermission,
              dense: true,
            ),
            const SizedBox(height: 10),
            const Text(
              "Popular Locations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                ActionChip(
                  avatar: Icon(
                    Icons.location_city,
                    size: 16,
                    color: Colors.brown,
                  ),
                  label: Text("Jaipur"),
                  onPressed: () {
                    // Navigate to SearchPage when chip tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SearchPage(initialQuery: "Jaipur"),
                      ),
                    );
                  },
                  backgroundColor: Colors.brown.withOpacity(0.1),
                ),
                ActionChip(
                  avatar: Icon(Icons.store, size: 16, color: Colors.brown),
                  label: Text("Gandhi Market"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                SearchPage(initialQuery: "Gandhi Market"),
                      ),
                    );
                  },
                  backgroundColor: Colors.brown.withOpacity(0.1),
                ),
                ActionChip(
                  avatar: Icon(Icons.home_work, size: 16, color: Colors.brown),
                  label: Text("Bagru"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(initialQuery: "Bagru"),
                      ),
                    );
                  },
                  backgroundColor: Colors.brown.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Results Title (Static now for nearby) ---
            const Text(
              "Popular Rentals Near You",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            // --- Property List (Only Nearby) ---
            _buildPropertyList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// --- BottomNavBar Widget (No changes needed here) ---
class BottomNavBar extends StatelessWidget {
  // ... (Same as before) ...
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  }); // Added super.key

  @override
  Widget build(BuildContext context) {
    // ... (BottomNavBar implementation remains the same)
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ), // Added labels for clarity
            BottomNavigationBarItem(
              icon: Image.asset(
                // Consider using an Icon instead if possible
                'assets/building_brown.png',
                width: 24,
                height: 24,
              ),
              label: "My Properties",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: "Messages",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.black54,
          type: BottomNavigationBarType.fixed, // Ensures all items are visible
          showSelectedLabels:
              false, // Keep labels hidden as per original design
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
