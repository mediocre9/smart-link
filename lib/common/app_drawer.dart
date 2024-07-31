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
                      _authService.getCurrentUser?.uid ?? "Undefined",
                      style: const TextStyle(fontSize: 7, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("CURO 360 Robot"),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.bluetoothHome,
                (context) => false,
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Smart Lock"),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.wifiHome,
                (context) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
