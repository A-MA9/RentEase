import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'constants.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatPage({
    Key? key,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isLoading = true;
  Timer? _messageTimer;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    // Set up periodic message refresh
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (_) => _loadMessages());
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadToken() async {
    String? savedToken = await storage.read(key: "access_token");

    if (savedToken != null) {
      setState(() {
        token = savedToken;
      });
      _loadMessages();
    } else {
      print("No token found");
    }
  }

  Future<void> _loadMessages() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final senderId = await storage.read(key: "user_id");
      if (senderId == null) {
        setState(() => isLoading = false);
        return;
      }

      final url = Uri.parse(
        '${baseUrl}/messages/${widget.receiverId}',
      );
      print('Loading messages from: $url');
      
      final token = await storage.read(key: "access_token");
      if (token == null) {
        setState(() => isLoading = false);
        return;
      }

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> messages = json.decode(response.body);
        setState(() {
          _messages.clear();
          _messages.addAll(messages.cast<Map<String, dynamic>>());
          isLoading = false;
        });
      } else {
        print('Failed to load messages: ${response.statusCode} - ${response.body}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error loading messages: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String? token = await storage.read(key: 'access_token');
    String? senderId = await storage.read(key: 'user_id');
    if (token == null || senderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to send messages'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final messageText = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender_id': senderId,
        'receiver_id': widget.receiverId,
        'content': messageText,
        'created_at': DateTime.now().toIso8601String(),
      });
    });

    try {
      final url = Uri.parse('${baseUrl}/messages/send');
      print('Sending message to: $url');
      
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          'receiver_id': widget.receiverId,
          'message': messageText,
          'message_type': 'text',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _loadMessages();
      } else {
        print('Failed to send message: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message')),
        );
      }
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMe = message['sender_id'] == widget.receiverId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTimestamp(message['timestamp'] ?? ''),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}
