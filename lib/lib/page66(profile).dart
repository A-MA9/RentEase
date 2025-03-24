/*
PROFILE PAGE INTEGRATED WITH PAGE 67 AND PAGE 77-79 (SETTINGS SCREEN) AND LOGOUT DIALOG AND TRANSACTION HISTORY SCREEN
*/

// import 'package:flutter/material.dart';
// import 'page67(profileEdit).dart'; // Import page67.dart
// import 'page77-79(Set&DelAccount).dart'; // Import page77-79.dart
// import 'page73(transactionHistory).dart'; // Import page66.dart which contains TransactionHistoryScreen

// void main() {
//   runApp(MaterialApp(
//     home: ProfilePage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       bottomNavigationBar: BottomNavBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Profile",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ProfileHeader(),
//             const SizedBox(height: 10),
//             ProfileMenu(
//               items: [
//                 ProfileMenuItem(Icons.home, "Rental application history"),
//                 ProfileMenuItem(Icons.apartment, "Past dorms history"),
//                 ProfileMenuItem(Icons.history, "Transaction history"),
//                 ProfileMenuItem(Icons.card_giftcard, "My voucher"),
//               ],
//               onTransactionHistoryTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TransactionHistoryScreen(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             ProfileMenu(
//               items: [
//                 ProfileMenuItem(Icons.headset_mic, "RentEase help"),
//                 ProfileMenuItem(Icons.settings, "Setting"),
//                 ProfileMenuItem(Icons.description, "Terms and conditions"),
//               ],
//               onSettingsTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SettingsScreen(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             LogoutButton(),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage(
//                     'https://documents.bcci.tv/resizedimageskirti/164_compress.png'),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Virat Kohli",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "+919649390637",
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//               Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PersonalInfoScreen(),
//                     ),
//                   );
//                 },
//                 child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: LinearProgressIndicator(
//                   value: 0.6,
//                   backgroundColor: Colors.grey[300],
//                   color: Colors.brown,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "6/10 Profile data is filled in",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Text(
//             "A complete profile can help us find more accurate results.",
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProfileMenu extends StatelessWidget {
//   final List<ProfileMenuItem> items;
//   final Function(BuildContext)? onSettingsTap;
//   final Function(BuildContext)? onTransactionHistoryTap;

//   ProfileMenu({
//     required this.items, 
//     this.onSettingsTap, 
//     this.onTransactionHistoryTap
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         children: items.map((item) => ProfileMenuTile(
//           item, 
//           onTap: item.title == "Setting" && onSettingsTap != null 
//               ? () => onSettingsTap!(context) 
//               : item.title == "Transaction history" && onTransactionHistoryTap != null
//                   ? () => onTransactionHistoryTap!(context)
//                   : null
//         )).toList(),
//       ),
//     );
//   }
// }

// class ProfileMenuTile extends StatelessWidget {
//   final ProfileMenuItem item;
//   final Function()? onTap;

//   ProfileMenuTile(this.item, {this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(item.icon, color: Colors.black),
//       title: Text(item.title),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
//       onTap: onTap ?? () {},
//     );
//   }
// }

// class ProfileMenuItem {
//   final IconData icon;
//   final String title;

//   ProfileMenuItem(this.icon, this.title);
// }

// class LogoutButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
//         ],
//       ),
//       child: ListTile(
//         leading: Icon(Icons.logout, color: Colors.red),
//         title: Text("Log out account", style: TextStyle(color: Colors.red)),
//         onTap: () {
//           _showLogoutDialog(context); // Added onTap handler to show logout dialog
//         },
//       ),
//     );
//   }

//   // Added new method to show the logout confirmation dialog
//   void _showLogoutDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.3,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       "Logout account!",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Text(
//                       "Are you sure you want to Logout?",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context); // Close dialog when Back is pressed
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF8D6E63),
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: Text(
//                           "Back",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           // Implement actual logout logic here
//                           Navigator.pop(context); // Close dialog when Log Out is pressed
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Colors.black),
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: Text(
//                           "Log Out",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class BottomNavBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20), 
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -3)),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20), 
//           topRight: Radius.circular(20),
//         ),
//         child: BottomNavigationBar(
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.message), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
//           ],
//           selectedItemColor: Colors.brown,
//           unselectedItemColor: Colors.black54,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           backgroundColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'page67(profileEdit).dart'; // Import page67.dart
// import 'page77-79(Set&DelAccount).dart'; // Import page77-79.dart
// import 'page73(transactionHistory).dart'; // Import page66.dart which contains TransactionHistoryScreen
// import 'page68(pastDormitory).dart'; // Import the new Past Dormitory screen

// void main() {
//   runApp(MaterialApp(
//     home: ProfilePage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       bottomNavigationBar: BottomNavBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Profile",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ProfileHeader(),
//             const SizedBox(height: 10),
//             ProfileMenu(
//               items: [
//                 ProfileMenuItem(Icons.home, "Rental application history"),
//                 ProfileMenuItem(Icons.apartment, "Past dorms history"),
//                 ProfileMenuItem(Icons.history, "Transaction history"),
//               ],
//               onTransactionHistoryTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TransactionHistoryScreen(),
//                   ),
//                 );
//               },
//               onPastDormsHistoryTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PastDormitoryScreen(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             ProfileMenu(
//               items: [
//                 ProfileMenuItem(Icons.headset_mic, "RentEase help"),
//                 ProfileMenuItem(Icons.settings, "Setting"),
//                 ProfileMenuItem(Icons.description, "Terms and conditions"),
//               ],
//               onSettingsTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SettingsScreen(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             LogoutButton(),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage(
//                     'https://documents.bcci.tv/resizedimageskirti/164_compress.png'),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Virat Kohli",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "+919649390637",
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//               Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PersonalInfoScreen(),
//                     ),
//                   );
//                 },
//                 child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: LinearProgressIndicator(
//                   value: 0.6,
//                   backgroundColor: Colors.grey[300],
//                   color: Colors.brown,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "6/10 Profile data is filled in",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Text(
//             "A complete profile can help us find more accurate results.",
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProfileMenu extends StatelessWidget {
//   final List<ProfileMenuItem> items;
//   final Function(BuildContext)? onSettingsTap;
//   final Function(BuildContext)? onTransactionHistoryTap;
//   final Function(BuildContext)? onPastDormsHistoryTap;

//   ProfileMenu({
//     required this.items, 
//     this.onSettingsTap, 
//     this.onTransactionHistoryTap,
//     this.onPastDormsHistoryTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         children: items.map((item) => ProfileMenuTile(
//           item, 
//           onTap: item.title == "Setting" && onSettingsTap != null 
//               ? () => onSettingsTap!(context) 
//               : item.title == "Transaction history" && onTransactionHistoryTap != null
//                   ? () => onTransactionHistoryTap!(context)
//                   : item.title == "Past dorms history" && onPastDormsHistoryTap != null
//                       ? () => onPastDormsHistoryTap!(context)
//                       : null
//         )).toList(),
//       ),
//     );
//   }
// }

// class ProfileMenuTile extends StatelessWidget {
//   final ProfileMenuItem item;
//   final Function()? onTap;

//   ProfileMenuTile(this.item, {this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(item.icon, color: Colors.black),
//       title: Text(item.title),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
//       onTap: onTap ?? () {},
//     );
//   }
// }

// class ProfileMenuItem {
//   final IconData icon;
//   final String title;

//   ProfileMenuItem(this.icon, this.title);
// }

// class LogoutButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
//         ],
//       ),
//       child: ListTile(
//         leading: Icon(Icons.logout, color: Colors.red),
//         title: Text("Log out account", style: TextStyle(color: Colors.red)),
//         onTap: () {
//           _showLogoutDialog(context); // Added onTap handler to show logout dialog
//         },
//       ),
//     );
//   }

//   // Added new method to show the logout confirmation dialog
//   void _showLogoutDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.3,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       "Logout account!",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Text(
//                       "Are you sure you want to Logout?",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context); // Close dialog when Back is pressed
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF8D6E63),
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: Text(
//                           "Back",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           // Implement actual logout logic here
//                           Navigator.pop(context); // Close dialog when Log Out is pressed
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Colors.black),
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: Text(
//                           "Log Out",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class BottomNavBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20), 
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -3)),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20), 
//           topRight: Radius.circular(20),
//         ),
//         child: BottomNavigationBar(
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.message), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
//           ],
//           selectedItemColor: Colors.brown,
//           unselectedItemColor: Colors.black54,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           backgroundColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'page67(profileEdit).dart'; // Import page67.dart
// import 'page77-79(Set&DelAccount).dart'; // Import page77-79.dart
// import 'page73(transactionHistory).dart'; // Import page66.dart which contains TransactionHistoryScreen
// import 'page68(pastDormitory).dart'; // Import the new Past Dormitory screen
// import '../home_screen.dart'; // Import the home screen

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       bottomNavigationBar: BottomNavBar(selectedIndex: 4, onItemTapped: (index) {
//         if (index != 4) { // If not already on profile
//           if (index == 0) { // Search
//             // Handle search navigation
//           } else if (index == 2) { // Home
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen()),
//             );
//           }
//           // Handle other navigation options as needed
//         }
//       }),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Profile",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ProfileHeader(),
//             const SizedBox(height: 10),
//             ProfileMenu(
//               items: [
//                 ProfileMenuItem(Icons.home, "Rental application history"),
//                 ProfileMenuItem(Icons.apartment, "Past dorms history"),
//                 ProfileMenuItem(Icons.history, "Transaction history"),
//               ],
//               onTransactionHistoryTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TransactionHistoryScreen(),
//                   ),
//                 );
//               },
//               onPastDormsHistoryTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PastDormitoryScreen(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             ProfileMenu(
//               items: [
//                 ProfileMenuItem(Icons.headset_mic, "RentEase help"),
//                 ProfileMenuItem(Icons.settings, "Setting"),
//                 ProfileMenuItem(Icons.description, "Terms and conditions"),
//               ],
//               onSettingsTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SettingsScreen(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             LogoutButton(),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage(
//                     'https://documents.bcci.tv/resizedimageskirti/164_compress.png'),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Virat Kohli",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "+919649390637",
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//               Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PersonalInfoScreen(),
//                     ),
//                   );
//                 },
//                 child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: LinearProgressIndicator(
//                   value: 0.6,
//                   backgroundColor: Colors.grey[300],
//                   color: Colors.brown,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "6/10 Profile data is filled in",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Text(
//             "A complete profile can help us find more accurate results.",
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProfileMenu extends StatelessWidget {
//   final List<ProfileMenuItem> items;
//   final Function(BuildContext)? onSettingsTap;
//   final Function(BuildContext)? onTransactionHistoryTap;
//   final Function(BuildContext)? onPastDormsHistoryTap;

//   ProfileMenu({
//     required this.items, 
//     this.onSettingsTap, 
//     this.onTransactionHistoryTap,
//     this.onPastDormsHistoryTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         children: items.map((item) => ProfileMenuTile(
//           item, 
//           onTap: item.title == "Setting" && onSettingsTap != null 
//               ? () => onSettingsTap!(context) 
//               : item.title == "Transaction history" && onTransactionHistoryTap != null
//                   ? () => onTransactionHistoryTap!(context)
//                   : item.title == "Past dorms history" && onPastDormsHistoryTap != null
//                       ? () => onPastDormsHistoryTap!(context)
//                       : null
//         )).toList(),
//       ),
//     );
//   }
// }

// class ProfileMenuTile extends StatelessWidget {
//   final ProfileMenuItem item;
//   final Function()? onTap;

//   ProfileMenuTile(this.item, {this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(item.icon, color: Colors.black),
//       title: Text(item.title),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
//       onTap: onTap ?? () {},
//     );
//   }
// }

// class ProfileMenuItem {
//   final IconData icon;
//   final String title;

//   ProfileMenuItem(this.icon, this.title);
// }

// class LogoutButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
//         ],
//       ),
//       child: ListTile(
//         leading: Icon(Icons.logout, color: Colors.red),
//         title: Text("Log out account", style: TextStyle(color: Colors.red)),
//         onTap: () {
//           _showLogoutDialog(context); // Added onTap handler to show logout dialog
//         },
//       ),
//     );
//   }

//   // Added new method to show the logout confirmation dialog
//   void _showLogoutDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.3,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       "Logout account!",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Text(
//                       "Are you sure you want to Logout?",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context); // Close dialog when Back is pressed
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF8D6E63),
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: Text(
//                           "Back",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           // Implement actual logout logic here
//                           Navigator.pop(context); // Close dialog when Log Out is pressed
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Colors.black),
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: Text(
//                           "Log Out",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class BottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;

//   const BottomNavBar({
//     required this.selectedIndex,
//     required this.onItemTapped,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20), 
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -3)),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20), 
//           topRight: Radius.circular(20),
//         ),
//         child: BottomNavigationBar(
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.message), label: ""),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
//           ],
//           currentIndex: selectedIndex,
//           onTap: onItemTapped,
//           selectedItemColor: Colors.brown,
//           unselectedItemColor: Colors.black54,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           backgroundColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'page67(profileEdit).dart'; // Import page67.dart
import 'page77-79(Set&DelAccount).dart'; // Import page77-79.dart
import 'page73(transactionHistory).dart'; // Import page66.dart which contains TransactionHistoryScreen
import 'page68(pastDormitory).dart'; // Import the new Past Dormitory screen
import '../home_screen.dart'; // Import the home screen

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavBar(selectedIndex: 4, onItemTapped: (index) {
        if (index != 4) { // If not already on profile
          if (index == 0) { // Search SEARECH SECTION
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 2) { // Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
          // Handle other navigation options as needed
        }
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ProfileHeader(),
            const SizedBox(height: 10),
            ProfileMenu(
              items: [
                ProfileMenuItem(Icons.home, "Rental application history"),
                ProfileMenuItem(Icons.apartment, "Past dorms history"),
                ProfileMenuItem(Icons.history, "Transaction history"),
              ],
              onTransactionHistoryTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryScreen(),
                  ),
                );
              },
              onPastDormsHistoryTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PastDormitoryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ProfileMenu(
              items: [
                ProfileMenuItem(Icons.headset_mic, "RentEase help"),
                ProfileMenuItem(Icons.settings, "Setting"),
                ProfileMenuItem(Icons.description, "Terms and conditions"),
              ],
              onSettingsTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            LogoutButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://documents.bcci.tv/resizedimageskirti/164_compress.png'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Virat Kohli",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "+919649390637",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalInfoScreen(),
                    ),
                  );
                },
                child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.grey[300],
                  color: Colors.brown,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "6/10 Profile data is filled in",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "A complete profile can help us find more accurate results.",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final List<ProfileMenuItem> items;
  final Function(BuildContext)? onSettingsTap;
  final Function(BuildContext)? onTransactionHistoryTap;
  final Function(BuildContext)? onPastDormsHistoryTap;

  ProfileMenu({
    required this.items, 
    this.onSettingsTap, 
    this.onTransactionHistoryTap,
    this.onPastDormsHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: items.map((item) => ProfileMenuTile(
          item, 
          onTap: item.title == "Setting" && onSettingsTap != null 
              ? () => onSettingsTap!(context) 
              : item.title == "Transaction history" && onTransactionHistoryTap != null
                  ? () => onTransactionHistoryTap!(context)
                  : item.title == "Past dorms history" && onPastDormsHistoryTap != null
                      ? () => onPastDormsHistoryTap!(context)
                      : null
        )).toList(),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final ProfileMenuItem item;
  final Function()? onTap;

  ProfileMenuTile(this.item, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.icon, color: Colors.black),
      title: Text(item.title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: onTap ?? () {},
    );
  }
}

class ProfileMenuItem {
  final IconData icon;
  final String title;

  ProfileMenuItem(this.icon, this.title);
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red),
        title: Text("Log out account", style: TextStyle(color: Colors.red)),
        onTap: () {
          _showLogoutDialog(context); // Added onTap handler to show logout dialog
        },
      ),
    );
  }

  // Added new method to show the logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Logout account!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Are you sure you want to Logout?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog when Back is pressed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8D6E63),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Implement actual logout logic here
                          Navigator.pop(context); // Close dialog when Log Out is pressed
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), 
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -3)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), 
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          ],
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.black54,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}