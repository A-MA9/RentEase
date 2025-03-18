import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/flutter_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ChatPage extends StatefulWidget {
  final int receiverId; // ID of the user you are chatting with

  const ChatPage({Key? key, required this.receiverId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController messageController = TextEditingController();
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken(); // Fetch token when the page loads
  }

  final apiUrl =
      kIsWeb
          ? 'http://localhost:8000/chat' // For web
          : 'http://10.0.2.2:8000/chat'; // For Android emulator

  Future<void> _loadToken() async {
    String? savedToken = await SecureStorage.storage.read(key: "access_token");

    if (savedToken != null) {
      setState(() {
        token = savedToken;
      });
      fetchMessages();
    } else {
      print("No token found");
    }
  }

  Future<void> fetchMessages() async {
    if (token == null) return;

    final url = Uri.parse(
      "http://localhost:8000/messages/${widget.receiverId}",
    );

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print("Failed to load messages: ${response.body}");
    }
  }

  Future<void> sendMessage(String message) async {
    if (token == null) return;

    final url = Uri.parse("http://localhost:8000/messages/send");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"receiver_id": widget.receiverId, "message": message}),
    );

    if (response.statusCode == 201) {
      fetchMessages();
      messageController.clear();
    } else {
      print("Failed to send message: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe =
                    msg['sender_id'] != widget.receiverId; // Correct check
                return Align(
                  alignment:
                      isMe ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.grey[300] : Colors.blue[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg['message']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: "Type a message..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      sendMessage(messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
