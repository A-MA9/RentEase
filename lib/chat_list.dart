import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'services/flutter_storage.dart';
import 'chat_page.dart'; // Import the chat screen
import 'constants.dart'; // Added import for constants

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List chats = [];
  String? token;

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  Future<void> fetchChats() async {
    String? savedToken = await SecureStorage.storage.read(key: "access_token");

    if (savedToken == null) {
      print("No token found");
      return;
    }

    try {
      final response = await Dio().get(
        '$baseUrl/chats', // Using baseUrl from constants.dart
        options: Options(headers: {"Authorization": "Bearer $savedToken"}),
      );
      setState(() {
        chats = response.data;
      });
    } catch (e) {
      print("Error fetching chats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        // ✅ Add the leading property to the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // ✅ Navigate back to the previous page
            Navigator.pop(context);
          },
        ),
      ),
      body:
          chats.isEmpty
              ? Center(
                child: Text(
                  "No messages yet",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
              : ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(chat['chat_partner_name'][0]),
                    ),
                    title: Text(chat['chat_partner_name']),
                    subtitle: Text(chat['message']),
                    trailing: Text(chat['timestamp']),
                    onTap: () {
                      // ✅ Navigate to ChatPage when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatPage(
                                receiverId:
                                    chat['chat_partner_id'], // Pass receiver ID
                                receiverName:
                                    chat['chat_partner_name'], // Pass name
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
