import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smart_link/config/colors/app_colors.dart';
import 'package:smart_link/config/router/routes.dart';
import 'package:smart_link/config/strings/strings.dart';
import 'package:smart_link/widgets/common.dart';
import '../../widgets/app_drawer.dart';
import 'package:local_auth/error_codes.dart' as biometric_error;
import 'package:http/http.dart' as http;

class BiometricScreen extends StatefulWidget {
  static final LocalAuthentication _authentication = LocalAuthentication();
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> with StandardAppWidgets {
  bool isAuthenticated = false;

  Future<void> on() async {
    try {
      await http.get(
        Uri.parse('http://${Strings.microControllerIp}/on_signal'),
        headers: {
          "Accept": "plain/text",
        },
      );
    } on HttpException catch (e) {
      log(e.message);
    }
  }

  Future<void> off() async {
    try {
      await http.get(
        Uri.parse('http://${Strings.microControllerIp}/off_signal'),
        headers: {
          "Accept": "plain/text",
        },
      );
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
          showSnackBarWidget(context, Strings.biometricLock);
          break;

        case biometric_error.permanentlyLockedOut:
          showSnackBarWidget(context, Strings.biometricPermanent);
          break;

        case biometric_error.notEnrolled:
          showSnackBarWidget(context, Strings.biometricEnrollment);
          break;

        case biometric_error.notAvailable:
          showSnackBarWidget(context, Strings.biometricNotSupported);
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
            icon: const Icon(Icons.bug_report_rounded),
            onPressed: () => Navigator.pushNamed(context, Routes.feedback),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => showAboutDialogWidget(context),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _startAuthentication(),
              icon: const Icon(Icons.fingerprint_rounded),
              iconSize: mediaQuery.size.height / 5,
              color: isAuthenticated ? AppColors.primary : const Color.fromARGB(255, 107, 107, 107),
            ),
            OutlinedButton(
              onPressed: () => off(),
              child: Text(
                "Switch Off",
                style: TextStyle(color: isAuthenticated ? AppColors.primary : const Color.fromARGB(255, 107, 107, 107)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
