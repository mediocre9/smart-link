import 'package:flutter/material.dart';
import '../config/strings/strings.dart';

mixin StandardAppWidgets {
  void showAboutDialogWidget(BuildContext context) {
    return showAboutDialog(
      context: context,
      applicationName: Strings.appName,
      applicationVersion: Strings.appVersion,
      applicationIcon: Image.asset(
        Strings.appLogo,
        width: MediaQuery.of(context).size.width / 5,
      ),
      children: [
        Text(
          Strings.copyright,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  void showSnackBarWidget(BuildContext context, String message,
      {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
