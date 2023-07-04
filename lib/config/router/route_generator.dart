import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/config/router/index.dart';
import 'package:remo_tooth/screens/authentication_screen/cubit/authentication_screen_cubit.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../../screens/wifi_home_screen/cubit/wifi_home_cubit.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generate(RouteSettings routeSettings) {
    var arg = routeSettings.arguments;

    switch (routeSettings.name) {
      case Routes.kSplash:
        return _pageTransition(const SplashScreen());

      case Routes.kAuth:
        return _pageTransition(
          BlocProvider(
            create: (_) => AuthenticationScreenCubit(),
            child: const AuthenticationScreen(),
          ),
        );

      case Routes.kBluetooth:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => BluetoothHomeCubit(),
            child: const BluetoothHomeScreen(),
          ),
        );

      case Routes.kBluetoothRemote:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => BluetoothRemoteCubit(),
            child: BluetoothRemoteScreen(device: (arg as BluetoothDevice)),
          ),
        );

      case Routes.kWifi:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => WifiHomeCubit(),
            child: const WifiHomeScreen(),
          ),
        );

      case Routes.kWifiRemote:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => WifiRemoteCubit(),
            child: WifiRemoteScreen(baseUrl: (arg as String)),
          ),
        );

      case Routes.kBiometric:
        return _pageTransition(const BiometricScreen());

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