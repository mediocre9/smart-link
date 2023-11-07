import 'package:flutter/material.dart';
import '../config/strings/app_strings.dart';

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

  void showSnackBarWidget(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
