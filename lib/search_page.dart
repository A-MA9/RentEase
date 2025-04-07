// // // import 'package:flutter/material.dart';
// // // import 'home_screen.dart';
// // // import 'filter_search.dart';
// // // import 'room_details.dart'; // Import the room.dart file

// // // class SearchPage extends StatefulWidget {
// // //   @override
// // //   _SearchPageState createState() => _SearchPageState();
// // // }

// // // class _SearchPageState extends State<SearchPage> {
// // //   final TextEditingController searchController = TextEditingController(
// // //     text: 'Jaipur',
// // //   );

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.grey[50],
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.white,
// // //         elevation: 0,
// // //         leading: IconButton(
// // //           icon: Icon(Icons.arrow_back, color: Colors.black),
// // //           onPressed:
// // //               () => Navigator.push(
// // //                 context,
// // //                 MaterialPageRoute(builder: (context) => HomeScreen()),
// // //               ),
// // //         ),
// // //         title: Container(
// // //           height: 45,
// // //           decoration: BoxDecoration(
// // //             color: Colors.grey[200],
// // //             borderRadius: BorderRadius.circular(30),
// // //             border: Border.all(color: Colors.grey.withOpacity(0.3)),
// // //           ),
// // //           child: TextField(
// // //             controller: searchController,
// // //             decoration: InputDecoration(
// // //               hintText: 'Search location...',
// // //               prefixIcon: Icon(Icons.search, color: Colors.brown),
// // //               suffixIcon: IconButton(
// // //                 icon: Icon(Icons.mic, color: Colors.brown),
// // //                 onPressed: () {},
// // //               ),
// // //               border: InputBorder.none,
// // //               contentPadding: EdgeInsets.symmetric(
// // //                 vertical: 12,
// // //                 horizontal: 15,
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Container(
// // //               height: 42,
// // //               child: ListView(
// // //                 scrollDirection: Axis.horizontal,
// // //                 children: [
// // //                   _buildFilterButton(
// // //                     "Filter",
// // //                     icon: Icons.filter_list,
// // //                     isSelected: true,
// // //                     onTap: () {
// // //                       Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(builder: (context) => FilterPage()),
// // //                       );
// // //                     },
// // //                   ),
// // //                   _buildFilterButton("Special Promo", icon: Icons.local_offer),
// // //                   _buildFilterButton(
// // //                     "Managed by Molly",
// // //                     icon: Icons.verified_user,
// // //                   ),
// // //                   _buildFilterButton("Top Rated", icon: Icons.star),
// // //                 ],
// // //               ),
// // //             ),
// // //             SizedBox(height: 20),
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 Text(
// // //                   "Found 99+ Dormitories",
// // //                   style: TextStyle(
// // //                     fontSize: 18,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: Colors.black87,
// // //                   ),
// // //                 ),
// // //                 Container(
// // //                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.grey[200],
// // //                     borderRadius: BorderRadius.circular(20),
// // //                   ),
// // //                   child: Row(
// // //                     children: [
// // //                       Icon(Icons.sort, size: 16, color: Colors.black54),
// // //                       SizedBox(width: 4),
// // //                       Text("Sort", style: TextStyle(color: Colors.black54)),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             SizedBox(height: 15),
// // //             Expanded(
// // //               child: ListView(
// // //                 children: [
// // //                   // First dormitory card with navigation to room.dart when clicked
// // //                   InkWell(
// // //                     onTap: () {
// // //                       Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(
// // //                           builder: (context) => RoomDetailsPage(
// // //                             dormitory: {
// // //                               'title': 'VIP Dormitory Jaipur Double Bed',
// // //                               'property_type': 'Woman',
// // //                               'location': 'Sindhi Camp',
// // //                               'owner_name': 'Virat',
// // //                               'owner_email': 'virat@example.com',
// // //                               'description': 'Wifi - AC - Attached bath - 24/7 UPS',
// // //                               'price_per_month': '5000',
// // //                             },
// // //                           ),
// // //                         ),
// // //                       );
// // //                     },
// // //                     child: _buildDormitoryCard(
// // //                       "Sindhi Camp",
// // //                       "VIP Dormitory Jaipur Double Bed",
// // //                       "Wifi - AC - Attached bath - 24/7 UPS",
// // //                       "assets/dorm1.jpg",
// // //                       "Woman",
// // //                       4.9,
// // //                       5000,
// // //                       "10% OFF",
// // //                       isFavorite: true,
// // //                     ),
// // //                   ),
// // //                   _buildDormitoryCard(
// // //                     "Badi chaupar, Jaipur",
// // //                     "VIP Dormitory Jaipur Double Bed",
// // //                     "Wifi - AC - Attached bath - 24/7 UPS",
// // //                     "assets/dorm2.jpg",
// // //                     "Mixed",
// // //                     4.2,
// // //                     4500,
// // //                     "15% OFF",
// // //                   ),
// // //                   _buildDormitoryCard(
// // //                     "Kalyan Circle",
// // //                     "VIP Dormitory Jaipur Single Bed",
// // //                     "Wifi - Ventilated - Attached bath - 12hr UPS",
// // //                     "assets/dorm3.jpg",
// // //                     "Man",
// // //                     4.8,
// // //                     5000,
// // //                     "20% OFF",
// // //                     isFavorite: true,
// // //                   ),
// // //                   _buildDormitoryCard(
// // //                     "Patrika gate, Jaipur",
// // //                     "VIP Dormitory Jaipur Single Bed",
// // //                     "Wifi - Ventilated - Common bath - No UPS",
// // //                     "assets/dorm4.jpg",
// // //                     "Man",
// // //                     4.9,
// // //                     4500,
// // //                     "25% OFF",
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //             SizedBox(height: 15),
// // //             Container(
// // //               width: double.infinity,
// // //               height: 50,
// // //               child: ElevatedButton.icon(
// // //                 onPressed: () {},
// // //                 icon: Icon(Icons.map, color: Colors.white),
// // //                 label: Text(
// // //                   "View on Map",
// // //                   style: TextStyle(color: Colors.white, fontSize: 16),
// // //                 ),
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Colors.brown,
// // //                   elevation: 2,
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(25),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildFilterButton(
// // //     String text, {
// // //     IconData? icon,
// // //     bool isSelected = false,
// // //     VoidCallback? onTap,
// // //   }) {
// // //     return Container(
// // //       margin: const EdgeInsets.only(right: 12.0),
// // //       child: ElevatedButton.icon(
// // //         onPressed:
// // //             onTap ??
// // //             () {
// // //               setState(() {
// // //                 // Handle filter selection
// // //               });
// // //             },
// // //         icon: Icon(
// // //           icon ?? Icons.filter_alt,
// // //           size: 18,
// // //           color: isSelected ? Colors.white : Colors.brown,
// // //         ),
// // //         label: Text(
// // //           text,
// // //           style: TextStyle(
// // //             color: isSelected ? Colors.white : Colors.black87,
// // //             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// // //           ),
// // //         ),
// // //         style: ElevatedButton.styleFrom(
// // //           backgroundColor: isSelected ? Colors.brown : Colors.white,
// // //           foregroundColor: Colors.black,
// // //           elevation: isSelected ? 2 : 0,
// // //           side: BorderSide(
// // //             color: isSelected ? Colors.brown : Colors.grey.withOpacity(0.5),
// // //           ),
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(20),
// // //           ),
// // //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDormitoryCard(
// // //     String location,
// // //     String title,
// // //     String facilities,
// // //     String imagePath,
// // //     String category,
// // //     double rating,
// // //     int price,
// // //     String discount, {
// // //     bool isFavorite = false,
// // //   }) {
// // //     return Container(
// // //       margin: EdgeInsets.only(bottom: 16),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(15),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withOpacity(0.05),
// // //             blurRadius: 10,
// // //             offset: Offset(0, 5),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Container(
// // //             height: 140,
// // //             child: Stack(
// // //               children: [
// // //                 ClipRRect(
// // //                   borderRadius: BorderRadius.only(
// // //                     topLeft: Radius.circular(15),
// // //                     topRight: Radius.circular(15),
// // //                   ),
// // //                   child: Image.asset(
// // //                     imagePath,
// // //                     width: double.infinity,
// // //                     height: 140,
// // //                     fit: BoxFit.cover,
// // //                   ),
// // //                 ),
// // //                 Positioned(
// // //                   top: 10,
// // //                   left: 10,
// // //                   child: Container(
// // //                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// // //                     decoration: BoxDecoration(
// // //                       color:
// // //                           category == "Woman"
// // //                               ? Colors.pink.withOpacity(0.8)
// // //                               : category == "Man"
// // //                               ? Colors.blue.withOpacity(0.8)
// // //                               : Colors.purple.withOpacity(0.8),
// // //                       borderRadius: BorderRadius.circular(20),
// // //                     ),
// // //                     child: Text(
// // //                       category,
// // //                       style: TextStyle(
// // //                         color: Colors.white,
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 12,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 if (discount.isNotEmpty)
// // //                   Positioned(
// // //                     top: 10,
// // //                     right: 10,
// // //                     child: Container(
// // //                       padding: EdgeInsets.symmetric(
// // //                         horizontal: 10,
// // //                         vertical: 5,
// // //                       ),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.yellow,
// // //                         borderRadius: BorderRadius.circular(20),
// // //                       ),
// // //                       child: Text(
// // //                         discount,
// // //                         style: TextStyle(
// // //                           fontSize: 12,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 Positioned(
// // //                   bottom: 10,
// // //                   right: 10,
// // //                   child: Container(
// // //                     padding: EdgeInsets.all(8),
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.white,
// // //                       shape: BoxShape.circle,
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.black.withOpacity(0.1),
// // //                           blurRadius: 5,
// // //                           offset: Offset(0, 2),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     child: Icon(
// // //                       isFavorite ? Icons.favorite : Icons.favorite_border,
// // //                       color: isFavorite ? Colors.red : Colors.grey,
// // //                       size: 20,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           Padding(
// // //             padding: const EdgeInsets.all(15.0),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   title,
// // //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// // //                 ),
// // //                 SizedBox(height: 5),
// // //                 Row(
// // //                   children: [
// // //                     Icon(Icons.location_on, color: Colors.brown, size: 16),
// // //                     SizedBox(width: 4),
// // //                     Text(
// // //                       location,
// // //                       style: TextStyle(
// // //                         color: Colors.brown,
// // //                         fontWeight: FontWeight.w500,
// // //                         fontSize: 14,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 SizedBox(height: 8),
// // //                 Text(
// // //                   facilities,
// // //                   style: TextStyle(color: Colors.grey, fontSize: 13),
// // //                 ),
// // //                 SizedBox(height: 10),
// // //                 Row(
// // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                   children: [
// // //                     Row(
// // //                       children: [
// // //                         Container(
// // //                           padding: EdgeInsets.symmetric(
// // //                             horizontal: 8,
// // //                             vertical: 4,
// // //                           ),
// // //                           decoration: BoxDecoration(
// // //                             color: Colors.brown.withOpacity(0.1),
// // //                             borderRadius: BorderRadius.circular(10),
// // //                           ),
// // //                           child: Row(
// // //                             children: [
// // //                               Icon(Icons.star, color: Colors.amber, size: 16),
// // //                               Text(
// // //                                 " $rating",
// // //                                 style: TextStyle(
// // //                                   fontWeight: FontWeight.bold,
// // //                                   color: Colors.brown,
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     Text(
// // //                       "₹$price/month",
// // //                       style: TextStyle(
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 16,
// // //                         color: Colors.brown,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:flutter/foundation.dart' show kIsWeb;

// // class SearchPage extends StatefulWidget {
// //   @override
// //   _SearchPageState createState() => _SearchPageState();
// // }

// // class _SearchPageState extends State<SearchPage> {
// //   late Future<List<dynamic>> properties;

// //   @override
// //   void initState() {
// //     super.initState();
// //     properties = fetchProperties();
// //   }

// //   Future<List<dynamic>> fetchProperties() async {
// //     // Use the correct URL for web
// //     final apiUrl =
// //         kIsWeb
// //             ? 'http://localhost:8000/properties' // For web
// //             : 'http://10.0.2.2:8000/properties'; // For Android emulator

// //     final response = await http.post(Uri.parse(apiUrl));
// //     // final response = await http.get(
// //     //   Uri.parse('http://YOUR_SERVER_IP:5000/properties'),
// //     // );

// //     if (response.statusCode == 200) {
// //       return json.decode(response.body);
// //     } else {
// //       throw Exception('Failed to load properties');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Search Properties'),
// //         backgroundColor: Colors.brown,
// //       ),
// //       body: FutureBuilder<List<dynamic>>(
// //         future: properties,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return Center(child: Text('No properties found'));
// //           }

// //           return ListView.builder(
// //             itemCount: snapshot.data!.length,
// //             itemBuilder: (context, index) {
// //               final property = snapshot.data![index];
// //               return PropertyCard(property: property);
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // class PropertyCard extends StatelessWidget {
// //   final Map<String, dynamic> property;

// //   PropertyCard({required this.property});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       margin: EdgeInsets.all(10),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //       child: Padding(
// //         padding: EdgeInsets.all(15),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               property['title'],
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 5),
// //             Row(
// //               children: [
// //                 Icon(Icons.location_on, color: Colors.brown, size: 16),
// //                 SizedBox(width: 4),
// //                 Text(property['location']),
// //               ],
// //             ),
// //             SizedBox(height: 5),
// //             Text(
// //               "Price: ₹${property['price_per_month']}/month",
// //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 10),
// //             Text("Owner: ${property['owner_name']}"),
// //             Text("Contact: ${property['owner_email']}"),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart' show kIsWeb;

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   late Future<List<dynamic>> properties;
//   final TextEditingController searchController = TextEditingController(
//     text: 'Jaipur',
//   );

//   @override
//   void initState() {
//     super.initState();
//     properties = fetchProperties();
//   }

//   Future<List<dynamic>> fetchProperties() async {
//     final apiUrl =
//         kIsWeb
//             ? 'http://localhost:8000/properties'
//             : 'http://10.0.2.2:8000/properties';
//     final response = await http.post(Uri.parse(apiUrl));

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load properties');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context); // Navigate back
//           },
//         ),
//         title: Container(
//           height: 45,
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(30),
//             border: Border.all(color: Colors.grey.withOpacity(0.3)),
//           ),
//           child: TextField(
//             controller: searchController,
//             decoration: InputDecoration(
//               hintText: 'Search location...',
//               prefixIcon: Icon(Icons.search, color: Colors.brown),
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.mic, color: Colors.brown),
//                 onPressed: () {},
//               ),
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: 12,
//                 horizontal: 15,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Filter Section
//             Container(
//               height: 42,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   _buildFilterButton(
//                     "Filter",
//                     icon: Icons.filter_list,
//                     isSelected: true,
//                   ),
//                   _buildFilterButton("Special Promo", icon: Icons.local_offer),
//                   _buildFilterButton(
//                     "Managed by Molly",
//                     icon: Icons.verified_user,
//                   ),
//                   _buildFilterButton("Top Rated", icon: Icons.star),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),

//             // Dormitory Count and Sort Button
//             FutureBuilder<List<dynamic>>(
//               future: properties,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Loading...",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.sort, size: 16, color: Colors.black54),
//                             SizedBox(width: 4),
//                             Text(
//                               "Sort",
//                               style: TextStyle(color: Colors.black54),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 } else if (snapshot.hasError ||
//                     !snapshot.hasData ||
//                     snapshot.data!.isEmpty) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "No Dormitories Found",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.sort, size: 16, color: Colors.black54),
//                             SizedBox(width: 4),
//                             Text(
//                               "Sort",
//                               style: TextStyle(color: Colors.black54),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 }

//                 final dormitoryCount = snapshot.data!.length;

//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Found $dormitoryCount Dormitories",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.sort, size: 16, color: Colors.black54),
//                           SizedBox(width: 4),
//                           Text("Sort", style: TextStyle(color: Colors.black54)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//             SizedBox(height: 15),

//             // Dormitory List
//             Expanded(
//               child: FutureBuilder<List<dynamic>>(
//                 future: properties,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(child: Text('No properties found'));
//                   }

//                   return ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       final property = snapshot.data![index];
//                       return PropertyCard(property: property);
//                     },
//                   );
//                 },
//               ),
//             ),

//             // View on Map Button
//             SizedBox(height: 15),
//             Container(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: Icon(Icons.map, color: Colors.white),
//                 label: Text(
//                   "View on Map",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.brown,
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper Method to Build Filter Buttons
//   Widget _buildFilterButton(
//     String text, {
//     IconData? icon,
//     bool isSelected = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(right: 12.0),
//       child: ElevatedButton.icon(
//         onPressed: () {
//           setState(() {
//             // Handle filter selection
//           });
//         },
//         icon: Icon(
//           icon ?? Icons.filter_alt,
//           size: 18,
//           color: isSelected ? Colors.white : Colors.brown,
//         ),
//         label: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black87,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isSelected ? Colors.brown : Colors.white,
//           foregroundColor: Colors.black,
//           elevation: isSelected ? 2 : 0,
//           side: BorderSide(
//             color: isSelected ? Colors.brown : Colors.grey.withOpacity(0.5),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         ),
//       ),
//     );
//   }
// }

// // Property Card Widget
// class PropertyCard extends StatelessWidget {
//   final Map<String, dynamic> property;

//   PropertyCard({required this.property});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               property['title'],
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 5),
//             Row(
//               children: [
//                 Icon(Icons.location_on, color: Colors.brown, size: 16),
//                 SizedBox(width: 4),
//                 Text(property['location']),
//               ],
//             ),
//             SizedBox(height: 5),
//             Text(
//               "Price: ₹${property['price_per_month']}/month",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text("Owner: ${property['owner_name']}"),
//             Text("Contact: ${property['owner_email']}"),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'room_details.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<dynamic>> _searchResultsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';
  Timer? _debounce;

  String get _baseUrl {
    return kIsWeb ? 'http://127.0.0.1:8000' : 'http://10.0.2.2:8000';
  }

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.initialQuery ?? '';
    _searchController.text = _currentQuery;
    _searchResultsFuture = _fetchSearchResults(_currentQuery);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 750), () {
      final query = _searchController.text.trim();
      if (query != _currentQuery) {
        _triggerSearch(query);
      }
    });
  }

  void _triggerSearch(String query) {
    final trimmedQuery = query.trim();
    print("Triggering search in SearchPage for: $trimmedQuery");
    setState(() {
      _currentQuery = trimmedQuery;
      _searchResultsFuture = _fetchSearchResults(trimmedQuery);
    });
  }

  Future<List<dynamic>> _fetchSearchResults(String query) async {
    if (query.isEmpty) return [];

    final searchUrl = Uri.parse(
      '$_baseUrl/properties/search',
    ).replace(queryParameters: {'location': query});

    print('SearchPage fetching from: $searchUrl');

    try {
      final response = await http
          .get(searchUrl, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('SearchPage found ${data.length} results.');
        return data;
      } else {
        print('SearchPage failed: ${response.statusCode} ${response.body}');
        throw Exception(
          'Failed to load search results (${response.statusCode})',
        );
      }
    } catch (e) {
      print('SearchPage error: $e');
      throw Exception('Error fetching search results: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search location...',
              prefixIcon: const Icon(Icons.search, color: Colors.brown),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 15,
              ),
            ),
            onSubmitted: (value) => _triggerSearch(value),
            textInputAction: TextInputAction.search,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterButton(
                    "Filter",
                    icon: Icons.filter_list,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Filter Tapped!")),
                      );
                    },
                  ),
                  _buildFilterButton("Special Promo", icon: Icons.local_offer),
                  _buildFilterButton("Top Rated", icon: Icons.star),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _searchResultsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 48,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                            onPressed: () => _triggerSearch(_currentQuery),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        _currentQuery.isEmpty
                            ? 'Enter a location to search'
                            : 'No properties found for "$_currentQuery".',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    );
                  }

                  final results = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Found ${results.length} Rentals for "$_currentQuery"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final property = results[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => RoomDetailsPage(
                                          propertyId: property['id'],
                                        ),
                                  ),
                                );
                              },
                              child: PropertyCard(
                                property: Map<String, dynamic>.from(property),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    String text, {
    IconData? icon,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: ActionChip(
        avatar:
            icon != null
                ? Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.brown,
                )
                : null,
        label: Text(text),
        onPressed:
            onTap ??
            () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("$text Filter Tapped!")));
            },
        backgroundColor: isSelected ? Colors.brown : Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
        side: BorderSide(color: Colors.grey.withOpacity(0.5)),
        elevation: isSelected ? 2 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final title = property['title'] ?? 'No Title';
    final location = property['location'] ?? 'Unknown Location';
    final propertyType = property['property_type'] ?? 'N/A';
    final priceRaw = property['price_per_month'];
    final price =
        priceRaw != null ? '₹$priceRaw per month' : 'Price not available';
    final imageUrl =
        (property['image_urls'] is List && property['image_urls'].isNotEmpty)
            ? property['image_urls'][0]
            : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          print('Tapped on search result: ${property['id']}');
          // TODO: Navigate to property details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child:
                  imageUrl != null
                      ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => const Center(
                              child: Icon(Icons.broken_image, size: 40),
                            ),
                      )
                      : const Center(
                        child: Icon(Icons.house_rounded, size: 50),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.brown.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    propertyType,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
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
