import 'package:flutter/material.dart';
import 'page67(profileEdit).dart'; // Import page67.dart
import 'page77-79(Set&DelAccount).dart'; // Import page77-79.dart
import 'page73(transactionHistory).dart'; // Import page66.dart which contains TransactionHistoryScreen
import 'page68(pastDormitory).dart'; // Import the new Past Dormitory screen
import '../home_screen.dart'; // Import the home screen
import 'favorites_screen.dart'; // Import the favorites screen which we'll create
import '../services/flutter_storage.dart';
import '../login.dart';

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
          } else if (index == 1) { // Favorites
            // Navigate to favorites page
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
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
                ProfileMenuItem(Icons.favorite, "My favorites"),
                ProfileMenuItem(Icons.home, "Rental application history"),
                ProfileMenuItem(Icons.apartment, "Past dorms history"),
                ProfileMenuItem(Icons.history, "Transaction history"),
              ],
              onFavoritesTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(),
                  ),
                );
              },
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
                'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'),
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
  final Function(BuildContext)? onFavoritesTap;

  ProfileMenu({
    required this.items, 
    this.onSettingsTap, 
    this.onTransactionHistoryTap,
    this.onPastDormsHistoryTap,
    this.onFavoritesTap,
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
                      : item.title == "My favorites" && onFavoritesTap != null
                          ? () => onFavoritesTap!(context)
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
        title: Text("Logout", style: TextStyle(color: Colors.red)),
        onTap: () {
          // Handle logout
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Logout"),
              content: Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    // Clear secure storage
                    await SecureStorage.storage.deleteAll();
                    
                    // Navigate to login screen
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text("Logout"),
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