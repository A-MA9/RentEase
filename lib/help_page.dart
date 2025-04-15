import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Keep it simple without centerTitle to allow custom spacing below
        title: const Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8), // Adds space below the AppBar
          const Text(
            'Help & Support',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildFAQ(
            question: 'How can I list my property on Rentease?',
            answer:
                'Go to the "Owner" section, tap on "Add Property", and fill in the required details like rent, address, and amenities.',
          ),
          _buildFAQ(
            question: 'How do I contact a property owner?',
            answer:
                'After viewing a property, tap the chat icon to send a message to the owner directly from the app.',
          ),
          _buildFAQ(
            question: 'Can I edit my property details after listing?',
            answer:
                'Yes, go to "My Properties" under your profile and tap the edit icon next to the listing.',
          ),
          _buildFAQ(
            question: 'Is my personal data safe on Rentease?',
            answer:
                'Yes, we take data privacy seriously. Your information is securely stored and never shared with third parties.',
          ),
          const SizedBox(height: 24),
          const Text(
            'Still Need Help?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email us'),
            subtitle: const Text('support@rentease.app'),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call us'),
            subtitle: const Text('+1 (800) 123-4567'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ({required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
