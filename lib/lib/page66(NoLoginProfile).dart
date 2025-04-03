import 'package:flutter/material.dart';
import '../home_screen.dart'; // Import the home screen
import 'page77-79(Setting).dart'; // Import the settings screen
import 'profilesignup.dart'; // Import the signup screen

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavBar(selectedIndex: 4, onItemTapped: (index) {
        if (index != 4) { // If not already on profile
          if (index == 0) { // Search SECTION
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
            GuestProfileHeader(),
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
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              onMenuItemTap: (context, title) {
                if (title == "RentEase help" || title == "Terms and conditions") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SimpleInfoScreen(title: title)),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class GuestProfileHeader extends StatelessWidget {
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
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Log in to access all features",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8D6E63),
              padding: EdgeInsets.symmetric(vertical: 12),
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Log In / Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final List<ProfileMenuItem> items;
  final Function(BuildContext)? onSettingsTap;
  final Function(BuildContext, String)? onMenuItemTap;

  ProfileMenu({
    required this.items, 
    this.onSettingsTap,
    this.onMenuItemTap,
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
              : () {
                  if (onMenuItemTap != null) {
                    onMenuItemTap!(context, item.title);
                  }
                }
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

class SimpleInfoScreen extends StatelessWidget {
  final String title;

  const SimpleInfoScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text("This is a simple information page."),
      ),
    );
  }
}