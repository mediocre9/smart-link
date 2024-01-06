import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_link/config/config.dart';
import 'firebase_options.dart';

Future<void> initializeFirebaseModule() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}

void configureLoadingIndicator() {
  EasyLoading.instance
    ..dismissOnTap = false
    ..userInteractions = false
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.dark
    ..animationStyle = EasyLoadingAnimationStyle.offset;
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeFirebaseModule();
    runApp(const SmartLinkApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });

  configureLoadingIndicator();
}

class SmartLinkApp extends StatelessWidget {
  const SmartLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      color: AppColors.primary,
      theme: AppTheme.darkTheme,
      builder: EasyLoading.init(),
      onGenerateRoute: RouteGenerator.generate,
      initialRoute: kDebugMode ? AppRoutes.bluetoothHome : AppRoutes.auth,
      debugShowCheckedModeBanner: kDebugMode ? true : false,
    );
  }
}
