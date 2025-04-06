import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'services/flutter_storage.dart';
import 'lib/page66(NoLoginProfile).dart' as GuestProfile; // Import the guest profile page
import 'lib/LoginProfile.dart' as LoggedInProfile; // Import the logged-in profile page
import 'lib/OwnerProfile.dart' as OwnerProfile; // Import the owner profile page - we'll create this next

class ProfileRouter extends StatelessWidget {
  const ProfileRouter({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _getUserLoginInfo() async {
    // Check if there's a valid token in secure storage
    final token = await SecureStorage.storage.read(key: 'access_token');
    final userType = await SecureStorage.storage.read(key: 'user_type');
    
    return {
      'isLoggedIn': token != null,
      'userType': userType ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserLoginInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while checking login status
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.brown),
            ),
          );
        }
        
        // Once we have the login info, route to the appropriate profile page
        final userInfo = snapshot.data ?? {'isLoggedIn': false, 'userType': ''};
        final isLoggedIn = userInfo['isLoggedIn'];
        final userType = userInfo['userType'];
        
        if (!isLoggedIn) {
          return GuestProfile.ProfilePage(); // Not logged in, show guest profile
        } else if (userType == 'owner') {
          return OwnerProfile.ProfilePage(); // Owner profile - we'll create this
        } else {
          return LoggedInProfile.ProfilePage(); // Regular seeker profile
        }
      },
    );
  }
} 