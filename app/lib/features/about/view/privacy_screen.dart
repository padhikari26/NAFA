import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the NAFA USA Mobile App!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'We created this app to connect our Nepali community through events, updates, photos, videos, and member information.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'By using this app, you agree to the following:',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Privacy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '• We only collect your name, phone number, and city for login and community features.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              '• We do not sell or share your data for marketing.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              '• Donations are processed securely through trusted providers (we don\'t store payment details).',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              '• You can request to update or delete your information anytime.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
