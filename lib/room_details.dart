// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'check_in.dart';
// import 'chat_owner.dart';
// import 'login.dart';
// import 'panorama.dart'; // Import your 3D Page
// import 'services/flutter_storage.dart';

// class RoomDetailsPage extends StatelessWidget {
//   final FlutterSecureStorage storage = const FlutterSecureStorage();
//   final Map<String, dynamic> dormitory;

//   const RoomDetailsPage({
//     Key? key,
//     required this.dormitory,
//   }) : super(key: key);

//   Future<bool> _isUserLoggedIn() async {
//     String? token = await SecureStorage.storage.read(key: "access_token");
//     print("🔹 Checking Stored Token: $token"); // Debugging
//     return token != null;
//   }

//   void _showLoginPrompt(BuildContext context) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text("Login Required"),
//             content: const Text("You need to log in to chat with the owner."),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Cancel"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()),
//                   );
//                 },
//                 child: const Text("Login"),
//               ),
//             ],
//           ),
//     );
//   }

//   void _handleChat(BuildContext context) async {
//     bool isLoggedIn = await _isUserLoggedIn();

//     if (!isLoggedIn) {
//       _showLoginPrompt(context);
//       return;
//     }

//     // Extract logged-in user's ID from storage
//     String? senderId = await storage.read(
//       key: "user_id",
//     ); // Ensure you save user ID during login
//     if (senderId == null) {
//       _showLoginPrompt(context);
//       return;
//     }

//     int roomOwnerId = 2; // The fixed owner ID

//     // Navigate to ChatScreen and pass sender and receiver IDs
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChatPage(receiverId: roomOwnerId),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.favorite_border, color: Colors.black),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(Icons.share, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Image.asset(
//                   'assets/dorm1.jpg',
//                   width: double.infinity,
//                   height: 250,
//                   fit: BoxFit.cover,
//                 ),
//                 Positioned(
//                   bottom: 10,
//                   right: 10,
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black.withOpacity(0.7),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 10,
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => PanoramaView()),
//                       );
//                     },
//                     icon: Icon(Icons.threed_rotation, color: Colors.white),
//                     label: Text(
//                       "3D View",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     dormitory['title'] ?? "VIP Dormitory Mansrovar Type A",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           dormitory['property_type'] ?? "Woman",
//                           style: TextStyle(color: Colors.white, fontSize: 12),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Icon(Icons.location_on, color: Colors.grey),
//                       Text(dormitory['location'] ?? "Central Samanabad"),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.orange),
//                       Text(" 4.8 (110)"),
//                       SizedBox(width: 10),
//                       Icon(Icons.verified, color: Colors.green),
//                       Text(" 911 successful transactions"),
//                     ],
//                   ),
//                   Divider(height: 30),
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundImage: AssetImage('assets/manager1.jpg'),
//                       ),
//                       SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Dormitory managed by ${dormitory['owner_name'] ?? 'Virat'}",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "Just got online",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Divider(height: 30),
//                   Text(
//                     "Description",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     dormitory['description'] ?? "This dormitory consists of 2 rooms, Room type A (VIP) is at the top with windows facing outside and towards the corridor.\n\nThere is also a regular AC cleaning service every 3 months. If you need help, you can contact the guard on duty 24/7.",
//                     style: TextStyle(fontSize: 14, color: Colors.black54),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '₹ ${dormitory['price_per_month'] ?? '5000'}/month',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             "Estimated Payment",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           OutlinedButton(
//                             onPressed: () => _handleChat(context),
//                             child: Text(
//                               "Chat Owner",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => CheckInDatePage(
//                                     dormitoryName: dormitory['title'] ?? 'Unknown Dormitory',
//                                     ownerEmail: dormitory['owner_email'] ?? '',
//                                     totalAmount: double.parse(dormitory['price_per_month']?.toString() ?? '0'),
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               "Check Out",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.brown,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 12,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'panorama.dart';

// class RoomDetailsPage extends StatefulWidget {
//   final int propertyId;

//   const RoomDetailsPage({super.key, required this.propertyId});

//   @override
//   State<RoomDetailsPage> createState() => _RoomDetailsPageState();
// }

// class _RoomDetailsPageState extends State<RoomDetailsPage> {
//   Map<String, dynamic>? dormitory;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchPropertyDetails();
//   }

//   Future<void> fetchPropertyDetails() async {
//     final url = Uri.parse(
//       'http://127.0.0.1:8000/properties/${widget.propertyId}',
//     );
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       setState(() {
//         dormitory = json.decode(response.body);
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       // Handle error
//       print('Failed to load property');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (dormitory == null) {
//       return const Scaffold(
//         body: Center(child: Text('Failed to load property details')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text(dormitory!['name']), centerTitle: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (dormitory!['panorama_image_url'] != null)
//               SizedBox(
//                 height: 250,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Panorama(
//                     child: Image.network(dormitory!['panorama_image_url']),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             Text(
//               dormitory!['name'],
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "₹${dormitory!['price']}/month",
//               style: const TextStyle(fontSize: 18, color: Colors.green),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               dormitory!['description'] ?? '',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             if (dormitory!['image_urls'] != null &&
//                 dormitory!['image_urls'] is List)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Gallery',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     height: 120,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: dormitory!['image_urls'].length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 10),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               dormitory!['image_urls'][index],
//                               width: 160,
//                               height: 120,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// room_details_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'panorama.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'check_in.dart';
import 'chat_owner.dart';
import 'login.dart';

class RoomDetailsPage extends StatefulWidget {
  final dynamic propertyId;

  const RoomDetailsPage({super.key, required this.propertyId});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  Map<String, dynamic>? dormitory;
  bool isLoading = true;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
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
        content: const Text("You need to log in to chat with the owner."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
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
        builder: (context) => ChatPage(
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
        setState(() {
          dormitory = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load property: ${response.statusCode} - ${response.body}');
        setState(() {
          isLoading = false;
          dormitory = null;
        });
      }
    } catch (e) {
      print('Error fetching property details: $e');
      setState(() {
        isLoading = false;
        dormitory = null;
      });
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
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
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
                            builder: (context) => PanoramaView(
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
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          style: const TextStyle(color: Colors.white, fontSize: 12),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  Row(
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
                                  builder: (context) => CheckInDatePage(
                                    dormitoryName: dormitory!['title'] ?? 'Unknown Dormitory',
                                    ownerEmail: dormitory!['owner_email'] ?? '',
                                    totalAmount: double.parse(dormitory!['price_per_month']?.toString() ?? '0'),
                                    propertyId: widget.propertyId.toString(),
                                  ),
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
