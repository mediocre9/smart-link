import 'dart:async';

import 'package:flutter/material.dart';

import '../../config/app_routes.dart';
import '../../config/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoute.BLUETOOTH_REMOTE_HOME);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: mediaQuery.size.width / 2,
            ),
            SizedBox(height: mediaQuery.size.height / 40),
            Text(
              AppString.APP_NAME,
              style: theme.displaySmall!.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(AppString.APP_DESCRIPTION, style: theme.labelMedium),
          ],
        ),
      ),
    );
  }
}
