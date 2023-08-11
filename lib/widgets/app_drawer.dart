import 'package:flutter/material.dart';
import 'package:smart_link/services/auth_service.dart';
import 'package:smart_link/widgets/common.dart';

import '../config/router/routes.dart';

class AppDrawer extends StatelessWidget with StandardAppWidgets {
  final AuthenticationService _authService = AuthenticationService();
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
                  foregroundImage:
                      NetworkImage(_authService.getCurrentUser!.photoURL!),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _authService.getCurrentUser!.displayName!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "ID: ${_authService.getCurrentUser!.uid}",
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
              Navigator.pushReplacementNamed(context, Routes.bluetoothHome);
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
                  Navigator.pushReplacementNamed(context, Routes.wifiHome);
                },
              ),
              ListTile(
                title: const Text("Fingerprint"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.biometric);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
