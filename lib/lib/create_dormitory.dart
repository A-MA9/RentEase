import 'package:flutter/material.dart';

class CreateDormitoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Dormitory',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text(
          'Create Dormitory Screen - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
} 