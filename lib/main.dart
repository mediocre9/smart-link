import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:remo_tooth/config/router/route_generator.dart';
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
      title: Strings.appName,
      color: AppColors.primary,
      initialRoute: Routes.auth,
      onGenerateRoute: RouteGenerator.generate,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
    );
  }
}
