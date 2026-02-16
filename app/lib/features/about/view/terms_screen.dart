import 'package:flutter/material.dart';
import 'package:nafausa/app/utils/helper.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the NAFA USA Mobile App!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'We created this app to connect our Nepali community through events, updates, photos, videos, and member information.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'By using this app, you agree to the following:',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '• Use the app respectfully and for community purposes only.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Content belongs to NAFA USA — please don\'t copy or misuse it.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 8),
            const Text(
              '• NAFA USA is not responsible for errors, interruptions, or third-party links.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Donations are voluntary and non-refundable.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 8),
            const Text(
              '• We may update these terms as needed.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'By logging in, you agree to our Privacy Policy & Terms of Use.',
              style: TextStyle(
                  fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Helper.openUrl('https://www.nafausa.org');
              },
              child: const Text(
                'For full details, visit: https://www.nafausa.org',
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
