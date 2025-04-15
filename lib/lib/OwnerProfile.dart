// import 'package:flutter/material.dart';
// import 'profileEdit.dart'; // Import profile edit page
// import 'page77-79(Set&DelAccount).dart'; // Import settings page
// import 'page73(transactionHistory).dart'; // Import transaction history page
// import '../owner_houses.dart'; // Import the owner's houses page
// import '../home_screen.dart'; // Import the home screen
// import 'create_dormitory.dart'; // We'll create this later
// import 'manage_bookings.dart'; // We'll create this later
// import '../services/flutter_storage.dart';
// import '../login.dart';
// import '../services/user_service.dart';
// import '../dormitory_details.dart'; // Import dormitory details page
// import '../help_page.dart'; // Import the help page
// import 'terms_and_conditions.dart'; // Import the terms and conditions page

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       bottomNavigationBar: BottomNavBar(
//         selectedIndex: 4,
//         onItemTapped: (index) {
//           if (index != 4) {
//             // If not already on profile
//             if (index == 0) {
//               // Search SECTION
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomeScreen()),
//               );
//             } else if (index == 2) {
//               // Home
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomeScreen()),
//               );
//             } else if (index == 1) {
//               // Buildings/Dormitories
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => OwnerHouses()),
//               );
//             }
//             // Handle other navigation options as needed
//           }
//         },
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Owner Profile",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ProfileHeader(),
//             const SizedBox(height: 10),
//             ProfileMenu(
//               items: [
//                 ProfileMenuItem(Icons.add_home_work, "Create new dormitory"),
//                 ProfileMenuItem(Icons.apartment, "Manage dormitories"),
//                 ProfileMenuItem(Icons.book_online, "View bookings"),
//                 ProfileMenuItem(Icons.history, "Transaction history"),
//               ],
//               onCreateDormitoryTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DormitoryDetailsPage(),
//                   ),
//                 );
//               },
//               onManageDormitoriesTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => OwnerHouses()),
//                 );
//               },
//               onManageBookingsTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ManageBookingsScreen(),
//                   ),
//                 );
//               },
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
//                 ProfileMenuItem(Icons.headset_mic, "RentEase help," ,onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const SettingsScreen()),
//                   );}),
//                 ProfileMenuItem(Icons.settings, "Setting"),
//                 ProfileMenuItem(Icons.description, "Terms and conditions"),
//               ],
//               onSettingsTap: (context) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SettingsScreen()),
//                 );
//               },
//               if (title == "RentEase help") {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => HelpPage()),
//                   );
//                 } else if (title == "Terms and conditions") {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => TermsAndConditionsPage(),
//                     ),
//                   );
//                 }
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
//     return FutureBuilder<Map<String, String?>>(
//       future: UserService.getLocalUserData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator(color: Colors.brown));
//         }

//         // Get user data from snapshot or use placeholders
//         final userData = snapshot.data ?? {};
//         final userName = userData['full_name'] ?? 'Property Owner';
//         final userPhone = userData['phone_number'] ?? '+91XXXXXXXXXX';

//         return Container(
//           padding: const EdgeInsets.all(16),
//           margin: const EdgeInsets.symmetric(horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 8,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundImage: NetworkImage(
//                       'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg',
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         userName,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         userPhone,
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                   Spacer(),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PersonalInfoScreen(),
//                         ),
//                       );
//                     },
//                     child: Icon(
//                       Icons.arrow_forward_ios,
//                       size: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: LinearProgressIndicator(
//                       value: 0.6,
//                       backgroundColor: Colors.grey[300],
//                       color: Colors.brown,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     "6/10 Profile data is filled in",
//                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "A complete profile can help attract more bookings.",
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class ProfileMenu extends StatelessWidget {
//   final List<ProfileMenuItem> items;
//   final Function(BuildContext)? onSettingsTap;
//   final Function(BuildContext)? onCreateDormitoryTap;
//   final Function(BuildContext)? onManageDormitoriesTap;
//   final Function(BuildContext)? onManageBookingsTap;
//   final Function(BuildContext)? onTransactionHistoryTap;

//   ProfileMenu({
//     required this.items,
//     this.onSettingsTap,
//     this.onCreateDormitoryTap,
//     this.onManageDormitoriesTap,
//     this.onManageBookingsTap,
//     this.onTransactionHistoryTap,
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
//         children:
//             items
//                 .map(
//                   (item) => ProfileMenuTile(
//                     item,
//                     onTap:
//                         item.title == "Setting" && onSettingsTap != null
//                             ? () => onSettingsTap!(context)
//                             : item.title == "Create new dormitory" &&
//                                 onCreateDormitoryTap != null
//                             ? () => onCreateDormitoryTap!(context)
//                             : item.title == "Manage dormitories" &&
//                                 onManageDormitoriesTap != null
//                             ? () => onManageDormitoriesTap!(context)
//                             : item.title == "Manage bookings" &&
//                                 onManageBookingsTap != null
//                             ? () => onManageBookingsTap!(context)
//                             : item.title == "Transaction history" &&
//                                 onTransactionHistoryTap != null
//                             ? () => onTransactionHistoryTap!(context)
//                             : null,
//                   ),
//                 )
//                 .toList(),
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
//         title: Text("Logout", style: TextStyle(color: Colors.red)),
//         onTap: () {
//           // Handle logout
//           showDialog(
//             context: context,
//             builder:
//                 (context) => AlertDialog(
//                   title: Text("Logout"),
//                   content: Text("Are you sure you want to logout?"),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text("Cancel"),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         // Clear secure storage
//                         await SecureStorage.storage.deleteAll();

//                         // Navigate to login screen
//                         Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(
//                             builder: (context) => LoginScreen(),
//                           ),
//                           (Route<dynamic> route) => false,
//                         );
//                       },
//                       child: Text("Logout"),
//                     ),
//                   ],
//                 ),
//           );
//         },
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
//         borderRadius: BorderRadius.only(
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
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         child: BottomNavigationBar(
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/building_brown.png',
//                 width: 24,
//                 height: 24,
//               ),
//               label: "",
//             ),
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
import 'profileEdit.dart'; // Import profile edit page
import 'page77-79(Set&DelAccount).dart'; // Import settings page
import 'page73(transactionHistory).dart'; // Import transaction history page
import '../owner_houses.dart'; // Import the owner's houses page
import '../home_screen.dart'; // Import the home screen
import 'create_dormitory.dart'; // We'll create this later
import 'manage_bookings.dart'; // We'll create this later
import '../services/flutter_storage.dart';
import '../login.dart';
import '../services/user_service.dart';
import '../dormitory_details.dart'; // Import dormitory details page
import '../help_page.dart'; // Import the help page
import 'terms_and_conditions.dart'; // Import the terms and conditions page
import '../chat_list.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 4,
        onItemTapped: (index) {
          if (index != 4) {
            // If not already on profile
            if (index == 0) {
              // Search SECTION
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (index == 2) {
              // Home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (index == 1) {
              // Buildings/Dormitories
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OwnerHouses()),
              );
            } else if (index == 3) {
              // Buildings/Dormitories
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatListScreen()),
              );
            }
            // Handle other navigation options as needed
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Owner Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ProfileHeader(),
            const SizedBox(height: 10),
            ProfileMenu(
              items: [
                ProfileMenuItem(
                  Icons.add_home_work,
                  "Create new dormitory",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DormitoryDetailsPage(),
                      ),
                    );
                  },
                ),
                ProfileMenuItem(
                  Icons.apartment,
                  "Manage dormitories",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OwnerHouses()),
                    );
                  },
                ),
                ProfileMenuItem(
                  Icons.book_online,
                  "View bookings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageBookingsScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenuItem(
                  Icons.history,
                  "Transaction history",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistoryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            ProfileMenu(
              items: [
                ProfileMenuItem(
                  Icons.headset_mic,
                  "RentEase help",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    );
                  },
                ),
                ProfileMenuItem(
                  Icons.settings,
                  "Setting",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
                ProfileMenuItem(
                  Icons.description,
                  "Terms and conditions",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsAndConditionsPage(),
                      ),
                    );
                  },
                ),
              ],
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
    return FutureBuilder<Map<String, String?>>(
      future: UserService.getLocalUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.brown));
        }

        // Get user data from snapshot or use placeholders
        final userData = snapshot.data ?? {};
        final userName = userData['full_name'] ?? 'Property Owner';
        final userPhone = userData['phone_number'] ?? '+91XXXXXXXXXX';

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userPhone,
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
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    ),
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
                "A complete profile can help attract more bookings.",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final List<ProfileMenuItem> items;

  const ProfileMenu({super.key, required this.items});

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
        children:
            items
                .map(
                  (item) => ProfileMenuTile(
                    item: item,
                    onTap: item.onTap, // Use the onTap from ProfileMenuItem
                  ),
                )
                .toList(),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final ProfileMenuItem item;
  final VoidCallback? onTap;

  const ProfileMenuTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.icon, color: Colors.black),
      title: Text(item.title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.black,
      ),
      onTap: onTap, // Use the provided onTap callback
    );
  }
}

class ProfileMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuItem(this.icon, this.title, {this.onTap});
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
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text("Logout", style: TextStyle(color: Colors.red)),
        onTap: () {
          // Handle logout
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Clear secure storage
                        await SecureStorage.storage.deleteAll();

                        // Navigate to login screen
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
            const BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/building_brown.png',
                width: 24,
                height: 24,
              ),
              label: "",
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            const BottomNavigationBarItem(icon: Icon(Icons.message), label: ""),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
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
