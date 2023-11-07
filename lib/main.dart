import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_link/config/router/route_generator.dart';
import 'firebase_options.dart';
import 'config/index.dart';

Future<void> initializeFirebaseModule() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeFirebaseModule();
    runApp(const SmartLinkApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class SmartLinkApp extends StatelessWidget {
  const SmartLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      color: AppColors.primary,
      theme: AppTheme.darkTheme,
      onGenerateRoute: RouteGenerator.generate,
      initialRoute: kDebugMode ? Routes.bluetoothHome : Routes.auth,
      debugShowCheckedModeBanner: kDebugMode ? true : false,
    );
  }
}
