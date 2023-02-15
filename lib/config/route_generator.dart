import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show MultiBlocProvider, BlocProvider;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/screens/home/cubit/home_cubit.dart';
import 'package:remo_tooth/screens/remote/cubit/remote_cubit.dart';
import 'package:remo_tooth/screens/remote/remote_screen.dart';
import 'app_routes.dart';
import '../screens/home/home_screen.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generate(RouteSettings routeSettings) {
    var arg = routeSettings.arguments;
    switch (routeSettings.name) {
      case AppRoute.HOME:
        return _pageTransition(BlocProvider(
            lazy: false,
            create: (_) => HomeCubit(),
            child: const HomeScreen()));

      case AppRoute.REMOTE:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => RemoteCubit(),
            child: RemoteScreen(device: (arg as BluetoothDevice)),
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
