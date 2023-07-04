import 'package:flutter/material.dart';
import '../config/strings/app_strings.dart';

mixin StandardAppWidgets {
  void showAboutDialogWidget(
      BuildContext context, MediaQueryData mediaQuery, ThemeData theme) {
    return showAboutDialog(
      context: context,
      applicationName: AppString.kAppName,
      applicationVersion: AppString.kAppVersion,
      applicationIcon: Image.asset(
        'assets/images/logo.png',
        width: mediaQuery.size.width / 5,
      ),
      children: [
        Text(
          AppString.kCopyrightStatement,
          style: theme.textTheme.labelMedium,
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
