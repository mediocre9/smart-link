import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_link/config/router/index.dart';
import 'package:smart_link/screens/authentication_screen/cubit/authentication_screen_cubit.dart';
import 'package:smart_link/screens/feedback_screen/cubit/feedback_cubit.dart';
import '../../screens/wifi_home_screen/cubit/wifi_home_cubit.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generate(RouteSettings routeSettings) {
    var arg = routeSettings.arguments;

    switch (routeSettings.name) {
      case Routes.auth:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => AuthenticationScreenCubit(
              authService: AuthenticationService(),
              internetConnectivity: Connectivity(),
            ),
            child: const AuthenticationScreen(),
          ),
        );

      case Routes.bluetoothHome:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => BluetoothHomeCubit(
              permission: BluetoothPermissionService(),
              bluetooth: BluetoothService(FlutterBluetoothSerial.instance),
            ),
            child: const BluetoothHomeScreen(),
          ),
        );

      case Routes.bluetoothRemote:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => BluetoothRemoteCubit(),
            child: BluetoothRemoteController(device: arg as BluetoothDevice),
          ),
        );

      case Routes.wifiHome:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => WifiHomeCubit(),
            child: const WifiHomeScreen(),
          ),
        );

      case Routes.wifiRemote:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => WifiRemoteCubit(),
            child: WifiRemoteScreen(baseUrl: (arg as String)),
          ),
        );

      case Routes.feedback:
        return _customPageTransition(
          route: BlocProvider(
            create: (_) => FeedbackCubit(
              feedbackService: FeedbackService(firestore: FirebaseFirestore.instance),
              service: AuthenticationService(),
            ),
            child: const FeedbackScreen(),
          ),
          pageTransitionBuilder: const FadeUpwardsPageTransitionsBuilder(),
        );

      case Routes.biometric:
        return _defaultPageTransition(route: const BiometricScreen());

      default:
        return _defaultPageTransition(route: _defaultRoute());
    }
  }

  static MaterialPageRoute<dynamic> _defaultPageTransition({
    required Widget route,
  }) {
    return MaterialPageRoute(builder: (context) => route);
  }

  static _CustomPageTransition<dynamic> _customPageTransition({
    required Widget route,
    required PageTransitionsBuilder pageTransitionBuilder,
  }) {
    return _CustomPageTransition(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      pageTransitionsBuilder: pageTransitionBuilder,
    );
  }

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

class _CustomPageTransition<T> extends PageRouteBuilder<T> {
  final PageTransitionsBuilder pageTransitionsBuilder;

  _CustomPageTransition({
    required RoutePageBuilder pageBuilder,
    required this.pageTransitionsBuilder,
  }) : super(pageBuilder: pageBuilder);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return pageTransitionsBuilder.buildTransitions(
      this,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
