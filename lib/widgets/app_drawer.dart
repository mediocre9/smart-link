import 'package:flutter/material.dart';
import 'package:remo_tooth/services/auth_service.dart';
import 'package:remo_tooth/widgets/common.dart';

import '../config/router/app_routes.dart';

class AppDrawer extends StatelessWidget with StandardAppWidgets {
  const AppDrawer({
    super.key,
  });

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
                    AuthService.getCurrentUser!.photoURL!,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AuthService.getCurrentUser!.displayName!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "ID: ${AuthService.getCurrentUser!.uid}",
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
              Navigator.pushReplacementNamed(context, Routes.kBluetooth);
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
                  Navigator.pushReplacementNamed(context, Routes.kWifi);
                },
              ),
              ListTile(
                title: const Text("Fingerprint"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.kBiometric);
                },
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text("Sign out"),
            onTap: () {
              AuthService.logOut().then((user) => {
                    if (user == null)
                      {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.kAuth,
                          (route) => false,
                        )
                      }
                    else
                      {
                        showSnackBarWidget(context, "Sign out failed!"),
                      }
                  });
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
