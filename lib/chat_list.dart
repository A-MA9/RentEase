import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'services/flutter_storage.dart';
import 'chat_page.dart'; // Import the chat screen

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

  final baseUrl =
      kIsWeb
          ? 'http://localhost:8000' // For web
          : 'http://10.0.2.2:8000'; // For Android emulator

  Future<void> fetchChats() async {
    String? savedToken = await SecureStorage.storage.read(key: "access_token");

    if (savedToken == null) {
      print("No token found");
      return;
    }

    try {
      final response = await Dio().get(
        '$baseUrl/chats', // ✅ Use proper URL for Android Emulator
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
      appBar: AppBar(title: Text("Chats")),
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
