/// Remo Tooth - is an application to remotely connect to
/// [arduino] device via [bluetooth] technology.
///
/// @Created Date: January 13th, 2023
/// @Copyright: It & Robotics - Electrical and Software Engineering Team
/// @Developed by: SAASH

import 'package:flutter/material.dart';
import 'package:remo_tooth/theme/theme.dart';
import 'config/app_routes.dart';
import 'config/app_strings.dart';
import 'config/route_generator.dart';

void main() {
  runApp(const RemoToothApp());
}

class RemoToothApp extends StatelessWidget {
  const RemoToothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppString.APP_NAME,
      initialRoute: AppRoute.HOME,
      onGenerateRoute: RouteGenerator.generate,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
    );
  }
}
