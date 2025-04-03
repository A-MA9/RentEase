import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Question mark icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF7E6E6E),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Information text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Transaction that have been viewed here will automatically be deleted after 30 day.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Additional info text
            Text(
              'For more info click help.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            
            // Help button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  // Add your help functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E6E6E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text(
                  'Help',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}