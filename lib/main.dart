import 'package:flutter/material.dart';
import 'package:remo_tooth/theme/theme.dart';
import 'config/app_routes.dart';
import 'config/app_strings.dart';
import 'config/route_generator.dart';

void main() {
  runApp(const SmartLinkApp());
}

class SmartLinkApp extends StatelessWidget {
  const SmartLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppString.APP_NAME,
      initialRoute: AppRoute.SPLASH_SCREEN,
      onGenerateRoute: RouteGenerator.generate,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
    );
  }
}
