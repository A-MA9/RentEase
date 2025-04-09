// room_details_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'panorama.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'check_in.dart';
import 'chat_owner.dart';
import 'login.dart';
import 'tenants_list.dart';

class RoomDetailsPage extends StatefulWidget {
  final dynamic propertyId;

  const RoomDetailsPage({super.key, required this.propertyId});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  Map<String, dynamic>? dormitory;
  bool isLoading = true;
  bool isFavorite = false;
  bool isCheckingFavorite = true;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We can refresh favorite status here to ensure it's up to date
    if (!isLoading && !isCheckingFavorite) {
      _checkFavorite();
    }
  }

  @override
  void dispose() {
    // Clean up any resources
    super.dispose();
  }

  Future<bool> _isUserLoggedIn() async {
    String? token = await storage.read(key: "access_token");
    print("🔹 Checking Stored Token: $token"); // Debugging
    return token != null;
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Required"),
        content: const Text("You need to log in to perform this action."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    bool isLoggedIn = await _isUserLoggedIn();
    if (!isLoggedIn) {
      _showLoginPrompt(context);
      return;
    }

    String? token = await storage.read(key: "access_token");
    if (token == null) {
      _showLoginPrompt(context);
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // Print debug info
      print('🔹 Attempting to toggle favorite for property: ${widget.propertyId}');
      print('🔹 User token available: ${token.isNotEmpty}');
      
      final url = Uri.parse('http://10.0.2.2:8000/favorites/toggle');
      final Map<String, dynamic> requestData = {
        'property_id': widget.propertyId.toString()
      };
      
      print('🔹 Sending request to $url');
      print('🔹 Request data: $requestData');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestData),
      );

      print('🔹 Response status code: ${response.statusCode}');
      print('🔹 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isFavorite = data['is_favorite'];
          isLoading = false;
        });
        
        // Show success message
        final action = isFavorite ? 'added to' : 'removed from';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Property $action favorites'),
            duration: const Duration(seconds: 2),
            backgroundColor: isFavorite ? Colors.green : Colors.grey,
          ),
        );
      } else {
        print('❌ Failed to toggle favorite: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update favorites. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error toggling favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network error. Please check your connection.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkFavorite() async {
    bool isLoggedIn = await _isUserLoggedIn();
    if (!isLoggedIn) {
      setState(() {
        isCheckingFavorite = false;
      });
      return;
    }

    String? token = await storage.read(key: "access_token");
    if (token == null) {
      setState(() {
        isCheckingFavorite = false;
      });
      return;
    }

    try {
      final url = Uri.parse('http://10.0.2.2:8000/check_favorite/${widget.propertyId}');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isFavorite = data['is_favorite'];
          isCheckingFavorite = false;
        });
      } else {
        print('Failed to check favorite: ${response.statusCode} - ${response.body}');
        setState(() {
          isCheckingFavorite = false;
        });
      }
    } catch (e) {
      print('Error checking favorite: $e');
      setState(() {
        isCheckingFavorite = false;
      });
    }
  }

  void _handleChat(BuildContext context) async {
    bool isLoggedIn = await _isUserLoggedIn();

    if (!isLoggedIn) {
      _showLoginPrompt(context);
      return;
    }

    // Extract logged-in user's ID from storage
    String? senderId = await storage.read(key: "user_id");
    if (senderId == null) {
      _showLoginPrompt(context);
      return;
    }

    // Navigate to ChatScreen and pass sender and receiver IDs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChatPage(
              receiverId: dormitory!['owner_id'],
              receiverName: dormitory!['owner_name'] ?? 'Property Owner',
            ),
      ),
    );
  }

  Future<void> fetchPropertyDetails() async {
    try {
      final url = Uri.parse(
        'http://10.0.2.2:8000/get_property/${widget.propertyId}',
      );
      print('Fetching property details from: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('🔹 Full property response: $responseData');
        
        // Check for owner_id to fetch owner email
        if (responseData.containsKey('owner_id') && responseData['owner_id'] != null) {
          String ownerId = responseData['owner_id'];
          print('🔹 Found owner_id: $ownerId');
          
          // Fetch owner email using owner_id
          await fetchOwnerEmail(ownerId).then((ownerEmail) {
            if (ownerEmail != null && ownerEmail.isNotEmpty) {
              responseData['owner_email'] = ownerEmail;
              print('🔹 Successfully fetched owner email: $ownerEmail');
            }
          });
        } else {
          print('❌ No owner_id found in response');
        }
        
        setState(() {
          dormitory = responseData;
          isLoading = false;
        });
        
        _checkFavorite();
      } else {
        print(
          'Failed to load property: ${response.statusCode} - ${response.body}',
        );
        setState(() {
          isLoading = false;
          dormitory = null;
          isCheckingFavorite = false;
        });
      }
    } catch (e) {
      print('Error fetching property details: $e');
      setState(() {
        isLoading = false;
        dormitory = null;
        isCheckingFavorite = false;
      });
    }
  }
  
  Future<String?> fetchOwnerEmail(String ownerId) async {
    try {
      // Endpoint to fetch user details by ID
      final url = Uri.parse('http://10.0.2.2:8000/get_user_email/$ownerId');
      print('Fetching owner email from: $url');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('🔹 Owner data response: $responseData');
        
        // Extract email from response
        if (responseData.containsKey('email')) {
          return responseData['email'];
        } else {
          print('❌ No email field found in user response');
          return null;
        }
      } else {
        print('❌ Failed to fetch owner email: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching owner email: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (dormitory == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load property details')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          dormitory!['title'] ?? 'Property Details',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          isCheckingFavorite 
          ? const SizedBox(
              width: 48,
              height: 48,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            )
          : IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black,
              ),
              onPressed: _toggleFavorite,
            ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dormitory!['panoramic_urls'] != null &&
                dormitory!['panoramic_urls'].isNotEmpty)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      dormitory!['panoramic_urls'][0],
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 250,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PanoramaView(
                                  imageUrl: dormitory!['panoramic_urls'][0],
                                ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.threed_rotation,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "3D View",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dormitory!['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          dormitory!['property_type'] ?? 'Unknown Type',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on, color: Colors.grey),
                      Text(dormitory!['location'] ?? 'Location not specified'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange),
                      const Text(" 4.8 (110)"),
                      const SizedBox(width: 10),
                      const Icon(Icons.verified, color: Colors.green),
                      const Text(" 911 successful transactions"),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/manager1.jpg'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dormitory managed by ${dormitory!['owner_name'] ?? 'Unknown Owner'}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Just got online",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    dormitory!['description'] ?? 'No description available',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  if (dormitory!['image_urls'] != null &&
                      dormitory!['image_urls'] is List &&
                      dormitory!['image_urls'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dormitory!['image_urls'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    dormitory!['image_urls'][index],
                                    width: 160,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 160,
                                        height: 120,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹${dormitory!['price_per_month'] ?? '0'}/month",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Estimated Payment",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TenantsListPage(
                                        propertyId: widget.propertyId,
                                      ),
                                ),
                              );
                            },
                            child: const Text(
                              "Ask Tenants",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => _handleChat(context),
                            child: const Text(
                              "Chat Owner",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    final ownerEmail = dormitory!['owner_email'];
                                    
                                    if (ownerEmail == null || ownerEmail.isEmpty) {
                                      print('⚠️ Warning: No owner email found for property ${widget.propertyId}, using owner_id instead');
                                      final ownerId = dormitory!['owner_id'];
                                    }
                                    
                                    return CheckInDatePage(
                                      dormitoryName: dormitory!['title'] ?? 'Unknown Dormitory',
                                      ownerEmail: ownerEmail ?? dormitory!['owner_id'] ?? '',
                                      totalAmount: double.parse(dormitory!['price_per_month']?.toString() ?? '0'),
                                      propertyId: widget.propertyId.toString(),
                                      dormitoryImage: dormitory!['image_urls'] != null && dormitory!['image_urls'].isNotEmpty
                                          ? dormitory!['image_urls'][0]
                                          : 'https://via.placeholder.com/400x200?text=No+Image',
                                      dormitoryDescription: dormitory!['description'] ?? '',
                                      amenities: {
                                        'tv': dormitory!['tv'] ?? false,
                                        'fan': dormitory!['fan'] ?? false,
                                        'ac': dormitory!['ac'] ?? false,
                                        'chair': dormitory!['chair'] ?? false,
                                        'ventilation': dormitory!['ventilation'] ?? false,
                                        'ups': dormitory!['ups'] ?? false,
                                        'sofa': dormitory!['sofa'] ?? false,
                                        'lamp': dormitory!['lamp'] ?? false,
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Check Out",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
