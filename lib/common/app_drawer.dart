import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/services/services.dart';

class AppDrawer extends StatelessWidget {
  final GoogleAuthService _authService = GoogleAuthService(
    firebaseAuth: FirebaseAuth.instance,
  );

  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 290,
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 35,
                  foregroundImage: NetworkImage(
                    _authService.getCurrentUser?.photoURL ??
                        "assets/images/logo.png",
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _authService.getCurrentUser?.displayName ?? "Undefined",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "ID: ${_authService.getCurrentUser?.uid ?? "Undefined"}",
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.connect_without_contact_rounded),
            title: const Text("HC-06"),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.bluetoothHome);
            },
          ),
          const Divider(),
          ExpansionTile(
            leading: const Icon(Icons.wifi_protected_setup_rounded),
            title: const Text("Node-MCU"),
            children: [
              ListTile(
                title: const Text("Locker"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.wifiHome);
                },
              ),
              ListTile(
                title: const Text("Fingerprint"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.biometric);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
