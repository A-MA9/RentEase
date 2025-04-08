import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/flutter_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ChatPage extends StatefulWidget {
  final String receiverId; // ID of the user you are chatting with
  final String receiverName;

  const ChatPage({
    Key? key,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController messageController = TextEditingController();
  String? token;
  int retryCount = 0;
  static const maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _loadToken(); // Fetch token when the page loads
  }

  final baseUrl =
      kIsWeb
          ? 'http://localhost:8000' // For web
          : 'http://10.0.2.2:8000'; // For Android emulator

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
    if (retryCount >= maxRetries) {
      print("Max retries reached for fetching messages");
      return;
    }

    final url = Uri.parse("$baseUrl/messages/${widget.receiverId}");
    print("Fetching messages from: $url");
    print("Using token: $token");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> decodedMessages = json.decode(response.body);
        if (mounted) {
          setState(() {
            messages = List<Map<String, dynamic>>.from(decodedMessages);
            retryCount = 0; // Reset retry count on success
          });
        }
      } else {
        print("Failed to load messages: ${response.body}");
        print("Status code: ${response.statusCode}");
        retryCount++;
        if (mounted && retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: 2));
          fetchMessages();
        }
      }
    } catch (e) {
      print("Error fetching messages: $e");
      retryCount++;
      if (mounted && retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: 2));
        fetchMessages();
      }
    }
  }

  Future<void> sendMessage(String message) async {
    if (token == null) return;

    final url = Uri.parse("$baseUrl/messages/send");
    print("Sending message to: $url");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "receiver_id": widget.receiverId,
          "message": message,
          "message_type": "text",
        }),
      );

      print("Send message response status: ${response.statusCode}");
      print("Send message response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        messageController.clear();
        retryCount = 0; // Reset retry count before fetching messages
        await fetchMessages();
      } else {
        print("Failed to send message: ${response.body}");
        print("Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending message: $e");
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
              reverse: false, // Keep messages in chronological order
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['sender_id'] != widget.receiverId;

                // Format timestamp
                DateTime timestamp = DateTime.parse(msg['timestamp']);
                String formattedTime =
                    "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['message'],
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        sendMessage(text);
                      }
                    },
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        sendMessage(messageController.text);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
