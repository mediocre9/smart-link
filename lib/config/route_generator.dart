import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/screens/wifi_remote/cubit/wifi_remote_cubit.dart';
import '../screens/bluetooth_home/cubit/home_cubit.dart';
import '../screens/bluetooth_home/home_screen.dart';
import '../screens/bluetooth_remote/cubit/bluetooth_remote_cubit.dart';
import '../screens/bluetooth_remote/remote_screen.dart';
import '../screens/wifi_home/cubit/wifi_home_cubit.dart';
import '../screens/wifi_home/wifi_home_Screen.dart';
import '../screens/wifi_remote/wifi_remote_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generate(RouteSettings routeSettings) {
    var arg = routeSettings.arguments;
    switch (routeSettings.name) {
      case AppRoute.BLUETOOTH_REMOTE_HOME:
        return _pageTransition(BlocProvider(
            lazy: false,
            create: (_) => BluetoothHomeCubit(),
            child: const BluetoothHomeScreen()));

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
