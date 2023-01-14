/// Remo Tooth - is an application to remotely connect to
/// [arduino] device via [bluetooth] technology.
///
/// @Created Date: January 13th, 2023
/// @Developers: It & Robotics - Electrical and Software Engineering Team

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:remo_tooth/firebase_options.dart';

import 'config/app_strings.dart';
import '../config/route_generator.dart';
import '../config/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  }

  runApp(const RemoToothApp());
}

class RemoToothApp extends StatelessWidget {
  const RemoToothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: AppString.APP_NAME,
      initialRoute: AppRoute.SIGN_UP,
      onGenerateRoute: RouteGenerator.generate,
      debugShowCheckedModeBanner: false,
    );
  }
}
