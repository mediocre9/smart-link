// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/common/common.dart';
import 'package:local_auth/error_codes.dart' as biometric_error;
import 'package:http/http.dart' as http;

// A prototype based code was written to test an IoT based project
class BiometricAuthScreen extends StatefulWidget {
  static final LocalAuthentication _authentication = LocalAuthentication();
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen>
    with StandardAppWidgets {
  bool isAuthenticated = false;

  Future<void> on() async {
    try {
      await http.get(
        Uri.parse('http://${AppStrings.deviceServerIP}/on_signal'),
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
        Uri.parse('http://${AppStrings.deviceServerIP}/off_signal'),
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
      isAuthenticated = await BiometricAuthScreen._authentication.authenticate(
        localizedReason: "IT & Robotics Engineering Society",
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
          showSnackBarWidget(context, AppStrings.biometricLock);
          break;

        case biometric_error.permanentlyLockedOut:
          showSnackBarWidget(context, AppStrings.biometricPermanent);
          break;

        case biometric_error.notEnrolled:
          showSnackBarWidget(context, AppStrings.biometricEnrollment);
          break;

        case biometric_error.notAvailable:
          showSnackBarWidget(context, AppStrings.biometricNotSupported);
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
          popupMenuButtonWidget(context),
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
              color: isAuthenticated
                  ? AppColors.primary
                  : const Color.fromARGB(255, 107, 107, 107),
            ),
            OutlinedButton(
              onPressed: () => off(),
              child: Text(
                "Switch Off",
                style: TextStyle(
                    color: isAuthenticated
                        ? AppColors.primary
                        : const Color.fromARGB(255, 107, 107, 107)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
