/// Remo Tooth - is an application to remotely connect to
/// [arduino] device via [bluetooth] technology.
///
/// @Created Date: January 13th, 2023
/// @Copyright: It & Robotics - Electrical and Software Engineering Team
/// @Developed by: SAASH

/// NOTE: The [Flutter_Bluetooth_Serial] library has current tracking issues.
/// and it has been repeatedly raised on the github forum that it is not
/// able to transmit or receive signals.
///
///
/// Raised Issues:
/// [https://github.com/edufolly/flutter_bluetooth_serial/issues/18]
/// [https://github.com/edufolly/flutter_bluetooth_serial/issues/174]
///
/// Problem Identification:
/// =======================
/// If we look at the library's source code their is socket I/O problem
/// because it is using the DEFAULT dummy [UUID] value.
///
///
/// Possible Fixes and Solution:
/// ============================
/// [https://github.com/edufolly/flutter_bluetooth_serial/issues/154#issuecomment-1158520603]
///
///
/// Why did i choose this library?
/// ==============================
/// If arduino uses [classic] bluetooth component like (HC-05, 06 ....), then the only library
/// that solves the problem is this library.
/// But if our arduino device does use [BLE] (Bluetooth Low Energy) component like (HM-10 BLE).
/// Then the problem can be resolved because we have a stable libary on the market
/// named [Flutter_Blue].
/// 
/// 
/// Solutions and Advices:
/// ======================
/// If this app does not solves the problem. Then we can use this application
/// [Serial Bluetooth Terminal]. 
/// Download Link: [https://play.google.com/store/apps/details?id=de.kai_morich.serial_bluetooth_terminal&hl=en&gl=US]
/// 
///
///
/// Current features in the app:
/// ============================
/// 1). Authentication system.
/// 2). It is able to find all paired devices.
/// 3). It is able to discover new devices.
/// 4). It is able to pair between devices.
/// 5). It is currently not able to send/recieve signals due to
/// technical problems.
///
/// Problematic code is on [Remote_Cubit] dart file.
/// screens -> remote -> cubit -> remote_cubit.dart

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:remo_tooth/firebase_options.dart';
import 'package:remo_tooth/theme/theme.dart';

import 'config/app_routes.dart';
import 'config/app_strings.dart';
import 'config/route_generator.dart';

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
    return MaterialApp(
      title: AppString.APP_NAME,
      initialRoute: AppRoute.SIGN_IN,
      onGenerateRoute: RouteGenerator.generate,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
    );
  }
}
