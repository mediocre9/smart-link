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
            "App Safety and Assurance",
            "We understand that downloading apps from sources other than the Official App stores might raise concerns. Our app is hosted on GitHub to ensure you receive the latest updates quickly and transparently. Hosting on GitHub allows us to provide direct access to new features and improvements as we continue to code and enhance the app. The app includes an update checker that you can use to check for new versions. If an update is available, you will be prompted to decide whether to download it. If you choose to update, you’ll be redirected to our GitHub page to get the latest version. We are committed to keeping our app safe, secure, and trustworthy. For your protection, we encourage you to regularly check for updates. This helps ensure you benefit from the latest security patches, enhancements, and any changes to our privacy policy.",
          ),
          _policySection(
            "Open Source Notice",
            "This project is open source and licensed under the MIT License. It is hosted on GitHub, where you can view, use, and contribute to the code. Contributions that align with our project policies and enhance the app are welcome. However, please respect the intellectual property of the original author, who remains the sole creator of this project. While the code is open source, it does not grant ownership or authorship rights.",
          ),
          _policySection(
            "Fingerprint Biometric Authentication",
            "This feature enhances security for locker access by using your phone’s fingerprint sensor. It ensures that only authorized users can unlock the lockers. The biometric data is processed solely on your device, not stored on our servers or within the smart lock firmware. This approach helps maintain a high level of security while protecting your personal information.",
          ),
          _policySection(
            "Data Security",
            "We use industry standard engineering practices to protect your data. Although no system is completely secure, we strive to ensure your information remains safe.",
          ),
          _policySection(
            "Crash and Error Logs",
            "We collect logs of crashes and application-level errors, including information about your device's operating system and manufacturer, to diagnose and address technical issues.",
          ),
          _policySection(
            "Location Permissions",
            "Our application utilizes location permissions in accordance with Android policy to ensure stable Bluetooth-based operations. The location permissions are necessary to enable the Bluetooth scan features of the Smart Link application. However, we do not store or track your precise location information.",
          ),
          _policySection(
            "Nearby Permissions",
            "Similar to location permissions, nearby permissions are utilized to facilitate seamless Bluetooth-based operations as required by the functionality of the Smart Link application.",
          ),
          _policySection(
            "Authentication Policy",
            "Users must authenticate with their Gmail account on first use. Re-authentication is not required for subsequent access unless the user signs out, ensuring both security and convenience.",
          ),
          _policySection(
            "Feedback Review",
            "User feedback is essential for understanding user experiences, addressing concerns, and making necessary enhancements to the Smart Link application.",
          ),
          _policySection(
            "Account Suspension",
            "We reserve the right to block individual users or organizations from accessing the app and associated devices in case of misuse or security breaches.",
          ),
          _policySection(
            "User Rights",
            "You have the right to request the deletion of your Gmail account from our servers. To make this request, you can either use the in-app feedback system or contact us directly. We will handle your request as quickly as possible.",
          ),
          _policySection(
            "Consent Details",
            "By using the Smart Link application, you agree to the collection and use of your information as outlined in this Privacy Policy. If you have any concerns or do not agree with any part of this Privacy Policy, we encourage you to refrain from using the application.",
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
