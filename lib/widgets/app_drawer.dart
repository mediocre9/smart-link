import 'package:flutter/material.dart';

import '../config/app_routes.dart';
import '../config/app_strings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                AppString.APP_NAME,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
          ListTile(
            title: const Text("HC-06"),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, AppRoute.BLUETOOTH_REMOTE_HOME);
            },
          ),
          ExpansionTile(
            title: const Text("Node-MCU"),
            children: [
              ListTile(
                title: const Text("Locker"),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoute.WIFI_REMOTE_HOME);
                },
              ),
              ListTile(
                title: const Text("Fingerprint"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoute.FINGERPRINT);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
