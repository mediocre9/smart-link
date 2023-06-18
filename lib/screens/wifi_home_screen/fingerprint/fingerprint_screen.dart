import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:remo_tooth/config/app_colors.dart';
import 'package:remo_tooth/config/app_strings.dart';
import '../../../widgets/app_drawer.dart';
import 'package:local_auth/error_codes.dart' as biometric_error;
import 'package:http/http.dart';

class FingerprintScreen extends StatefulWidget {
  static final LocalAuthentication _authentication = LocalAuthentication();
  const FingerprintScreen({super.key});

  @override
  State<FingerprintScreen> createState() => _FingerprintScreenState();
}

class _FingerprintScreenState extends State<FingerprintScreen> {
  static const String DEFAULT_GATEWAY = "192.168.4.1";
  bool isAuthenticated = false;

  Future<void> on() async {
    try {
      await get(Uri.parse('http://$DEFAULT_GATEWAY/on_signal'),
          headers: {"Accept": "plain/text"});
    } catch (e) {}
  }

  Future<void> off() async {
    try {
      await get(Uri.parse('http://$DEFAULT_GATEWAY/off_signal'),
          headers: {"Accept": "plain/text"});
              setState(() {
      isAuthenticated = false;
    });
    } catch (e) {}
  }

  Future<void> _startAuthentication() async {
    try {
      isAuthenticated = await FingerprintScreen._authentication.authenticate(
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
          _showSnackBar(AppString.TEMPORARY_LOCKED_OUT_ERROR);
          break;

        case biometric_error.permanentlyLockedOut:
          _showSnackBar(AppString.PERMANENT_LOCKED_OUT_ERROR);
          break;

        case biometric_error.notEnrolled:
          _showSnackBar(AppString.BIOMETRIC_NOT_ENROLLED_ERROR);
          break;

        case biometric_error.notAvailable:
          _showSnackBar(AppString.HARDWARE_SUPPORT_NOT_AVAILABLE);
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
                applicationName: AppString.APP_NAME,
                applicationVersion: AppString.APP_VERSION,
                applicationIcon: Image.asset(
                  'assets/images/logo.png',
                  width: mediaQuery.size.width / 5,
                ),
                children: [
                  Text(
                    AppString.COPYRIGHT,
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
                  ? AppColors.PRIMARY_COLOR
                  : const Color.fromARGB(255, 107, 107, 107),
            ),
            OutlinedButton(
              onPressed: () => off(),
              child: Text(
                "Switch Off",
                style: TextStyle(
                    color: isAuthenticated
                        ? AppColors.PRIMARY_COLOR
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
