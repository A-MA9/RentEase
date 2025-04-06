import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the home screen
import 'lib/page66(NoLoginProfile).dart'; // Import the profile page
import 'chat_list.dart'; // Import the chat page
import 'profile_router.dart'; // Import the profile router
import 'lib/favorites_screen.dart'; // Import the favorites screen

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2, // Home is selected
        onItemTapped: (index) {
          if (index == 4) {
            // Person icon
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileRouter()),
            );
          } else if (index == 0) {
            // Search icon
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            // Favorites icon
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
          } else if (index == 3) {
            // Chat icon
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatListScreen()),
            );
          }
          // Handle other navigation as needed
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Header with Logo and Notification Icon**
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/image.png', height: 140, width: 140),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const Icon(
                    Icons.notifications,
                    size: 28,
                    color: Colors.black,
                  ),
                ],
              ),
            ),

            // **Title & Subtitle**
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dormitory Finder',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Finding and renting a dormitory is easy.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // **Search Bar (Navigates to HomeScreen)**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  // **Navigate to home_screen.dart**
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Search...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // **Full Ad Image (Not Cut)**
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/ad.png',
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Reusing the BottomNavBar component from ProfilePage for consistency
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({required this.selectedIndex, required this.onItemTapped});

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
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -3),
          ),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: "",
            ),
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
