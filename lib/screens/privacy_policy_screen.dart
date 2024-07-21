import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _policySection(
            'Why the App is Not on Official App Stores',
            "This app isn't on official app stores like Google Play due to new testing policies introduced by Google on November 13, 2023. Meeting these requirements is currently beyond our means.",
          ),
          _policySection(
            'Transparency and Trust',
            "We want to assure you that this app does not contain any harmful code. The code is released under the MIT license, ensuring that you can review it yourself to verify its safety and integrity.",
          ),
          _policySection(
            'Crash and Error Logs',
            'We collect logs of crashes and application-level errors, including information about your device\'s operating system and manufacturer, to diagnose and address technical issues.',
          ),
          _policySection(
            'Location Permissions',
            'Our application utilizes location permissions in accordance with Android policy to ensure stable Bluetooth-based operations. The location permissions are necessary to enable certain features of the Smart Link application that require access to nearby devices for Bluetooth-based operations. However, we do not store or track your precise location information.',
          ),
          _policySection(
            'Nearby Permissions',
            'Similar to location permissions, nearby permissions are utilized to facilitate seamless Bluetooth-based operations as required by the functionality of the Smart Link application.',
          ),
          _policySection(
            'Authentication Policy',
            'Users must authenticate with their Gmail account on first use. Re-authentication is not required for subsequent access unless the user signs out, ensuring both security and convenience.',
          ),
          _policySection(
            'Feedback Review',
            'User feedback is essential for understanding user experiences, addressing concerns, and making necessary enhancements to the Smart Link application.',
          ),
          _policySection(
            'Account Suspension',
            'We reserve the right to block individual users or organizations from accessing the app and associated IOT based devices in case of misuse or security breaches.',
          ),
          _policySection(
            'Consent Details',
            'By using the Smart Link application, you agree to the collection and use of your information as outlined in this Privacy Policy. If you have any concerns or do not agree with any part of this Privacy Policy, we encourage you to refrain from using the application.',
          ),
        ],
      ),
    );
  }

  Widget _policySection(String title, String description) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(description),
    );
  }
}
