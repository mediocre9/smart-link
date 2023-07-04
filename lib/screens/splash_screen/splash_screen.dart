import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remo_tooth/widgets/common.dart';
import '../../config/index.dart';

class SplashScreen extends StatefulWidget with StandardAppWidgets {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.kBluetooth,
          (route) => false,
        );
      });
    } else {
      Future(() => {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.kAuth,
              (route) => false,
            )
          });
    }
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
              AppString.kAppLogoPath,
              width: mediaQuery.size.width / 2,
            ),
            SizedBox(height: mediaQuery.size.height / 40),
            Text(
              AppString.kAppName,
              style: theme.displaySmall!.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(AppString.kAppDescription, style: theme.labelMedium),
          ],
        ),
      ),
    );
  }
}
