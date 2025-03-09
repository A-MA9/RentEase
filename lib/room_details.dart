// // import 'package:flutter/material.dart';
// // import 'check_in.dart';
// // import 'chat_owner.dart';

// // class RoomDetailsPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back, color: Colors.black),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.favorite_border, color: Colors.black),
// //             onPressed: () {},
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.share, color: Colors.black),
// //             onPressed: () {},
// //           ),
// //         ],
// //       ),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Image.asset(
// //               'assets/dorm1.jpg',
// //               width: double.infinity,
// //               height: 250,
// //               fit: BoxFit.cover,
// //             ),
// //             Padding(
// //               padding: EdgeInsets.all(16.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     "VIP Dormitory Mansrovar Type A",
// //                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //                   ),
// //                   SizedBox(height: 5),
// //                   Row(
// //                     children: [
// //                       Container(
// //                         padding: EdgeInsets.symmetric(
// //                           horizontal: 10,
// //                           vertical: 5,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: Colors.red,
// //                           borderRadius: BorderRadius.circular(20),
// //                         ),
// //                         child: Text(
// //                           "Woman",
// //                           style: TextStyle(color: Colors.white, fontSize: 12),
// //                         ),
// //                       ),
// //                       SizedBox(width: 10),
// //                       Icon(Icons.location_on, color: Colors.grey),
// //                       Text("Central Samanabad"),
// //                     ],
// //                   ),
// //                   SizedBox(height: 10),
// //                   Row(
// //                     children: [
// //                       Icon(Icons.star, color: Colors.orange),
// //                       Text(" 4.8 (110)"),
// //                       SizedBox(width: 10),
// //                       Icon(Icons.verified, color: Colors.green),
// //                       Text(" 911 successful transactions"),
// //                     ],
// //                   ),
// //                   Divider(height: 30),
// //                   Row(
// //                     children: [
// //                       CircleAvatar(
// //                         backgroundImage: AssetImage('assets/manager1.jpg'),
// //                       ),
// //                       SizedBox(width: 10),
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "Dormitory managed by Virat",
// //                             style: TextStyle(fontWeight: FontWeight.bold),
// //                           ),
// //                           Text(
// //                             "Just got online",
// //                             style: TextStyle(color: Colors.grey),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                   Divider(height: 30),
// //                   Text(
// //                     "Description",
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                   ),
// //                   SizedBox(height: 5),
// //                   Text(
// //                     "This dormitory consists of 2 rooms, Room type A (VIP) is at the top with windows facing outside and towards the corridor.\n\nThere is also a regular AC cleaning service every 3 months. If you need help, you can contact the guard on duty 24/7.",
// //                     style: TextStyle(fontSize: 14, color: Colors.black54),
// //                   ),
// //                   SizedBox(height: 20),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             "₹ 5000/month",
// //                             style: TextStyle(
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                           Text(
// //                             "Estimated Payment",
// //                             style: TextStyle(color: Colors.grey),
// //                           ),
// //                         ],
// //                       ),
// //                       Row(
// //                         children: [
// //                           OutlinedButton(
// //                             onPressed: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => ChatApp(),
// //                                 ),
// //                               );
// //                             },
// //                             child: Text(
// //                               "Chat Owner",
// //                               style: TextStyle(color: Colors.black),
// //                             ),
// //                           ),
// //                           SizedBox(width: 10),
// //                           ElevatedButton(
// //                             onPressed: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => CheckInDatePage(),
// //                                 ),
// //                               );
// //                             },
// //                             child: Text(
// //                               "Check Out",
// //                               style: TextStyle(color: Colors.white),
// //                             ),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.brown,
// //                               padding: EdgeInsets.symmetric(
// //                                 horizontal: 20,
// //                                 vertical: 12,
// //                               ),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // void main() {
// //   runApp(MaterialApp(home: RoomDetailsPage()));
// // }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'check_in.dart';
// import 'chat_owner.dart';
// import 'login.dart'; // Import your Login Page

// class RoomDetailsPage extends StatelessWidget {
//   Future<bool> _isUserLoggedIn() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool("isLoggedIn") ?? false;
//   }

//   void _handleChat(BuildContext context) async {
//     bool isLoggedIn = await _isUserLoggedIn();

//     if (isLoggedIn) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ChatApp()),
//       );
//     } else {
//       _showLoginPrompt(context);
//     }
//   }

//   void _showLoginPrompt(BuildContext context) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Text("Login Required"),
//             content: Text("You need to log in to chat with the owner."),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text("Cancel"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()),
//                   );
//                 },
//                 child: Text("Login"),
//               ),
//             ],
//           ),
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
//             Image.asset(
//               'assets/dorm1.jpg',
//               width: double.infinity,
//               height: 250,
//               fit: BoxFit.cover,
//             ),
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "VIP Dormitory Mansrovar Type A",
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
//                           "Woman",
//                           style: TextStyle(color: Colors.white, fontSize: 12),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Icon(Icons.location_on, color: Colors.grey),
//                       Text("Central Samanabad"),
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
//                             "Dormitory managed by Virat",
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
//                     "This dormitory consists of 2 rooms, Room type A (VIP) is at the top with windows facing outside and towards the corridor.\n\nThere is also a regular AC cleaning service every 3 months. If you need help, you can contact the guard on duty 24/7.",
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
//                             "₹ 5000/month",
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
//                                   builder: (context) => CheckInDatePage(),
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

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'check_in.dart';
import 'chat_owner.dart';
import 'login.dart';

class RoomDetailsPage extends StatelessWidget {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> _isUserLoggedIn() async {
    String? token = await storage.read(key: "access_token");
    return token != null;
  }

  void _handleChat(BuildContext context) async {
    bool isLoggedIn = await _isUserLoggedIn();

    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatApp()),
      );
    } else {
      _showLoginPrompt(context);
    }
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/dorm1.jpg',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "VIP Dormitory Mansrovar Type A",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Woman",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.location_on, color: Colors.grey),
                      Text("Central Samanabad"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      Text(" 4.8 (110)"),
                      SizedBox(width: 10),
                      Icon(Icons.verified, color: Colors.green),
                      Text(" 911 successful transactions"),
                    ],
                  ),
                  Divider(height: 30),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/manager1.jpg'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dormitory managed by Virat",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Just got online",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: 30),
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "This dormitory consists of 2 rooms, Room type A (VIP) is at the top with windows facing outside and towards the corridor.\n\nThere is also a regular AC cleaning service every 3 months. If you need help, you can contact the guard on duty 24/7.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹ 5000/month",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Estimated Payment",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => _handleChat(context),
                            child: Text(
                              "Chat Owner",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckInDatePage(),
                                ),
                              );
                            },
                            child: Text(
                              "Check Out",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
