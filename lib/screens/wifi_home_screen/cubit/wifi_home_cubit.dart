import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:app_settings/app_settings.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_link/common/common.dart';
import 'package:smart_link/config/config.dart';
import 'package:local_auth/error_codes.dart' as biometric_error;
import 'package:local_auth/local_auth.dart';
import 'package:smart_link/extensions.dart';
part 'wifi_home_state.dart';

class WifiHomeCubit extends Cubit<WifiHomeState> with StandardAppWidgets {
  String baseUrl = "http://${AppStrings.deviceServerIP}";
  final LocalAuthentication _biometricAuth = LocalAuthentication();

  WifiHomeCubit() : super(Initial());

  Future<void> connectToESP8266() async {
    try {
      safeEmit(Connecting());
      http.Response response = await http.post(
        Uri.parse("$baseUrl/connect"),
        headers: {
          'Content-Type': 'text/plain',
        },
        body: FirebaseAuth.instance.currentUser?.email,
      );
      if (response.statusCode == 200) {
        safeEmit(Connected(response.body));
        safeEmit(Initial());
        await sendOnMessage();
        return;
      }
      safeEmit(NotConnected(response.body));
      safeEmit(Initial());
      return;
    } catch (e) {
      safeEmit(NotConnected("Please connect to the Smart Lock network!"));
      safeEmit(Initial());
      await Future.delayed(1.5.seconds);
      await AppSettings.openAppSettingsPanel(AppSettingsPanelType.wifi);
    }
  }

  Future<void> sendOnMessage() async {
    try {
      bool isAuthenticated = await _isBiometricAuth();
      if (isAuthenticated) {
        final response = await http.post(
          Uri.parse('$baseUrl/unlock'),
          headers: {
            'Content-Type': 'text/plain',
          },
          body: FirebaseAuth.instance.currentUser?.email,
        );

        if (response.statusCode == 200) {
          safeEmit(OnSignal(response.body, AppColors.primary));
          return;
        }
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case biometric_error.lockedOut:
          safeEmit(BiometricError(AppStrings.biometricLock));

        case biometric_error.permanentlyLockedOut:
          safeEmit(BiometricError(AppStrings.biometricPermanent));

        case biometric_error.notEnrolled:
          safeEmit(BiometricError(AppStrings.biometricEnrollment));

        case biometric_error.notAvailable:
          safeEmit(BiometricError(AppStrings.biometricNotSupported));

        default:
      }
      safeEmit(Initial());
    } on Exception catch (e) {
      log(e.toString());
      safeEmit(NetworkError(
          "Something went wrong! Please contact support for further assistance."));
    }
  }

  Future<void> sendOffMessage() async {
    safeEmit(Connecting());
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lock'),
        headers: {
          'Content-Type': 'text/plain',
        },
        body: FirebaseAuth.instance.currentUser?.email,
      );
      safeEmit(OffSignal(response.body, Colors.grey));
    } on Exception catch (e) {
      log(e.toString());
      safeEmit(NetworkError(
          "Something went wrong! Please contact support for further assistance."));
    } finally {
      safeEmit(Initial());
    }
  }

  Future<bool> _isBiometricAuth() async {
    return await _biometricAuth.authenticate(
      localizedReason: "Biometric authentication required",
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
        useErrorDialogs: true,
      ),
    );
  }
}
