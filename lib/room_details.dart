import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'check_in.dart';
import 'chat_owner.dart';
import 'login.dart';
import 'panorama.dart'; // Import your 3D Page
import 'services/flutter_storage.dart';

class RoomDetailsPage extends StatelessWidget {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Map<String, dynamic> dormitory;

  const RoomDetailsPage({
    Key? key,
    required this.dormitory,
  }) : super(key: key);

  Future<bool> _isUserLoggedIn() async {
    String? token = await SecureStorage.storage.read(key: "access_token");
    print("🔹 Checking Stored Token: $token"); // Debugging
    return token != null;
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

  void _handleChat(BuildContext context) async {
    bool isLoggedIn = await _isUserLoggedIn();

    if (!isLoggedIn) {
      _showLoginPrompt(context);
      return;
    }

    // Extract logged-in user's ID from storage
    String? senderId = await storage.read(
      key: "user_id",
    ); // Ensure you save user ID during login
    if (senderId == null) {
      _showLoginPrompt(context);
      return;
    }

    int roomOwnerId = 2; // The fixed owner ID

    // Navigate to ChatScreen and pass sender and receiver IDs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(receiverId: roomOwnerId),
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
            Stack(
              children: [
                Image.asset(
                  'assets/dorm1.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PanoramaView()),
                      );
                    },
                    icon: Icon(Icons.threed_rotation, color: Colors.white),
                    label: Text(
                      "3D View",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dormitory['title'] ?? "VIP Dormitory Mansrovar Type A",
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
                          dormitory['property_type'] ?? "Woman",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.location_on, color: Colors.grey),
                      Text(dormitory['location'] ?? "Central Samanabad"),
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
                            "Dormitory managed by ${dormitory['owner_name'] ?? 'Virat'}",
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
                    dormitory['description'] ?? "This dormitory consists of 2 rooms, Room type A (VIP) is at the top with windows facing outside and towards the corridor.\n\nThere is also a regular AC cleaning service every 3 months. If you need help, you can contact the guard on duty 24/7.",
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
                            "₹ ${dormitory['price_per_month'] ?? '5000'}/month",
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
                                  builder: (context) => CheckInDatePage(
                                    dormitoryName: dormitory['title'] ?? 'Unknown Dormitory',
                                    ownerEmail: dormitory['owner_email'] ?? '',
                                    totalAmount: double.parse(dormitory['price_per_month']?.toString() ?? '0'),
                                  ),
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
