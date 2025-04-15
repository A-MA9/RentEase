import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 8),
          Text(
            'Terms & Conditions',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Welcome to Rentease!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Text(
            'By using our app, you agree to the following terms and conditions. Please read them carefully before continuing.',
          ),
          SizedBox(height: 24),

          Text(
            '1. Account Responsibility',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'You are responsible for maintaining the confidentiality of your account credentials. Any activity under your account will be your responsibility.',
          ),
          SizedBox(height: 16),

          Text(
            '2. Property Listings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Owners must provide accurate and honest details about their property. Rentease reserves the right to remove listings that violate our guidelines.',
          ),
          SizedBox(height: 16),

          Text(
            '3. Communication',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Users must maintain respectful and appropriate communication. Misuse may result in suspension or banning of accounts.',
          ),
          SizedBox(height: 16),

          Text(
            '4. Data Privacy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'We value your privacy. Your personal data will not be shared without consent. Refer to our Privacy Policy for full details.',
          ),
          SizedBox(height: 16),

          Text(
            '5. Changes to Terms',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'We may update these terms occasionally. Continued use of the app after changes constitutes acceptance of the new terms.',
          ),
          SizedBox(height: 24),

          Text(
            'If you have any questions or concerns, feel free to contact us at support@rentease.app.',
          ),
        ],
      ),
    );
  }
}
