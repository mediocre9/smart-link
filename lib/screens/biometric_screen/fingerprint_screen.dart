import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:remo_tooth/config/colors/app_colors.dart';
import 'package:remo_tooth/config/strings/app_strings.dart';
import '../../widgets/app_drawer.dart';
import 'package:local_auth/error_codes.dart' as biometric_error;
import 'package:http/http.dart';

class BiometricScreen extends StatefulWidget {
  static final LocalAuthentication _authentication = LocalAuthentication();
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  bool isAuthenticated = false;

  Future<void> on() async {
    try {
      await get(Uri.parse('http://${AppString.kNodeMCUDefaultIp}/on_signal'),
          headers: {"Accept": "plain/text"});
    } on HttpException catch (e) {
      log(e.message);
    }
  }

  Future<void> off() async {
    try {
      await get(Uri.parse('http://${AppString.kNodeMCUDefaultIp}/off_signal'),
          headers: {"Accept": "plain/text"});
      setState(() {
        isAuthenticated = false;
      });
    } on HttpException catch (e) {
      log(e.message);
    }
  }

  Future<void> _startAuthentication() async {
    try {
      isAuthenticated = await BiometricScreen._authentication.authenticate(
        localizedReason: "IT & Robotics Engineering.",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      if (isAuthenticated) {
        await on();
        setState(() {});
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case biometric_error.lockedOut:
          _showSnackBar(AppString.kBiometricLockMessage);
          break;

        case biometric_error.permanentlyLockedOut:
          _showSnackBar(AppString.kBiometricPermanentLockMessage);
          break;

        case biometric_error.notEnrolled:
          _showSnackBar(AppString.kBiometricEnrollmentMessage);
          break;

        case biometric_error.notAvailable:
          _showSnackBar(AppString.kBiometricSupportMessage);
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fingerprint"),
        actions: [
          IconButton(
            onPressed: () {
              showAboutDialog(
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
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              );
            },
            icon: const Icon(Icons.info_outline_rounded),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _startAuthentication(),
              icon: const Icon(Icons.fingerprint_rounded),
              iconSize: mediaQuery.size.height / 5,
              color: isAuthenticated
                  ? AppColors.kPrimary
                  : const Color.fromARGB(255, 107, 107, 107),
            ),
            OutlinedButton(
              onPressed: () => off(),
              child: Text(
                "Switch Off",
                style: TextStyle(
                    color: isAuthenticated
                        ? AppColors.kPrimary
                        : const Color.fromARGB(255, 107, 107, 107)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
