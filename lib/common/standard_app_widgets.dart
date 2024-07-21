import 'package:flutter/material.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/screens/settings_screen.dart';

enum PopupItems {
  settings,
  about,
}

mixin StandardAppWidgets {
  void showAboutDialogWidget(BuildContext context) {
    return showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: AppStrings.appVersion,
      applicationIcon: Image.asset(
        AppStrings.appLogo,
        width: MediaQuery.of(context).size.width / 5,
      ),
      children: [
        Text(
          AppStrings.copyright,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  void showSnackBarWidget(
    BuildContext context,
    String message, {
    Color? color,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  PopupMenuButton<PopupItems> popupMenuButtonWidget(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white60,
      ),
      color: AppColors.appBar,
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: PopupItems.settings,
            child: Text("Settings"),
          ),
          const PopupMenuItem(
            value: PopupItems.about,
            child: Text("About"),
          ),
        ];
      },
      onSelected: (value) async {
        switch (value) {
          case PopupItems.settings:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
            break;

          default:
            showAboutDialogWidget(context);
        }
      },
    );
  }
}
