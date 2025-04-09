import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'services/flutter_storage.dart';
import 'home_screen.dart';
import 'home_page.dart';
import 'home_page_owner.dart';
import 'profile_router.dart';
import 'chat_list.dart';
import 'favorites_screen.dart';
import 'owner_houses.dart';
import 'search_page.dart';

class NavigationHelper {
  static Future<bool> isUserOwner() async {
    final userType = await SecureStorage.storage.read(key: 'user_type');
    return userType == 'owner';
  }

  static Future<void> navigateToHomeBasedOnUserType(BuildContext context) async {
    final isOwner = await isUserOwner();
    if (isOwner) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageOwner()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  static Future<void> handleBottomNavigation(BuildContext context, int index, {String? searchQuery}) async {
    final isOwner = await isUserOwner();
    
    switch (index) {
      case 0: // Search
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(initialQuery: searchQuery ?? ''),
          ),
        );
        break;
      case 1: // Favorites or My Properties
        if (isOwner) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OwnerHouses()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FavoritesScreen()),
          );
        }
        break;
      case 2: // Home
        await navigateToHomeBasedOnUserType(context);
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
}

class SmartBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isOwner;

  const SmartBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ),
            BottomNavigationBarItem(
              icon: isOwner 
                ? Image.asset('assets/building_brown.png', width: 24, height: 24)
                : Icon(Icons.favorite_border),
              label: isOwner ? "My Properties" : "Favorites",
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
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
} 