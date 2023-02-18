import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/screens/splash_screen/splash_screen.dart';
import '../screens/bluetooth_home_screen/bluetooth_home_screen.dart';
import '../screens/bluetooth_home_screen/bluetooth_remote_screen/bluetooth_remote_screen.dart';
import '../screens/bluetooth_home_screen/bluetooth_remote_screen/cubit/bluetooth_remote_cubit.dart';
import '../screens/bluetooth_home_screen/cubit/bluetooth_home_cubit.dart';
import '../screens/wifi_home_screen/cubit/wifi_home_cubit.dart';
import '../screens/wifi_home_screen/wifi_home_Screen.dart';
import '../screens/wifi_home_screen/wifi_remote_screen/wifi_remote_screen.dart';
import '../screens/wifi_home_screen/wifi_remote_screen/cubit/wifi_remote_cubit.dart';
import 'app_routes.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generate(RouteSettings routeSettings) {
    var arg = routeSettings.arguments;

    switch (routeSettings.name) {
      case AppRoute.SPLASH_SCREEN:
        return _pageTransition(const SplashScreen());

      case AppRoute.BLUETOOTH_REMOTE_HOME:
        return _pageTransition(
          BlocProvider(
              lazy: false,
              create: (_) => BluetoothHomeCubit(),
              child: const BluetoothHomeScreen()),
        );

      case AppRoute.BLUETOOTH_REMOTE_CONTROLLER:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => BluetoothRemoteCubit(),
            child: BluetoothRemoteScreen(device: (arg as BluetoothDevice)),
          ),
        );

      case AppRoute.WIFI_REMOTE_HOME:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => WifiHomeCubit(),
            child: const WifiHomeScreen(),
          ),
        );

      case AppRoute.WIFI_REMOTE_CONTROLLER:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => WifiRemoteCubit(),
            child: WifiRemoteScreen(baseUrl: (arg as String)),
          ),
        );

      default:
        return _pageTransition(_defaultRoute());
    }
  }

  static _pageTransition(Widget route) =>
      CupertinoPageRoute(builder: (_) => route);

  static _defaultRoute() {
    return const Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text(
          'Route doesn\'t exists.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
