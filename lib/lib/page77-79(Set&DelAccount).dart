import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationExpanded = false;
  bool emailNotifications = true;
  bool chatNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to ProfilePage
          },
        ),
        title: Text(
          "Setting",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNotificationCard(),
            SizedBox(height: 12),
            _buildDeleteAccountCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isNotificationExpanded = !isNotificationExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Notification",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isNotificationExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            if (isNotificationExpanded) ...[
              SizedBox(height: 10),
              _buildNotificationOption(
                "Recommendations via mail",
                emailNotifications,
                (value) {
                  setState(() {
                    emailNotifications = value;
                  });
                },
              ),
              _buildNotificationOption(
                "Notifications of chat",
                chatNotifications,
                (value) {
                  setState(() {
                    chatNotifications = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationOption(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.black87)),
          Checkbox(
            value: value,
            onChanged: (val) => onChanged(val!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            activeColor: Colors.brown,
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountCard() {
    return GestureDetector(
      onTap: () {
        _showDeleteConfirmationDialog();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline, color: Colors.red, size: 24),
              SizedBox(width: 10),
              Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Are you sure you want to delete your account from RentEase?",
          ),
          content: Text(
            "Once you delete this account, all the data will be lost and cannot be recovered!",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
