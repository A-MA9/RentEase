import 'package:flutter/material.dart';

class ManageBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Bookings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text(
          'Manage Bookings Screen - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
} 