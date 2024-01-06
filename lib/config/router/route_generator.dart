import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_link/config/config.dart';
import 'routes.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generate(RouteSettings routeSettings) {
    var arg = routeSettings.arguments;

    switch (routeSettings.name) {
      case AppRoutes.auth:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => AuthenticationScreenCubit(
              authService: GoogleAuthService(
                firebaseAuth: FirebaseAuth.instance,
              ),
              connectivityService: ConnectivityService(),
            ),
            child: const AuthenticationScreen(),
          ),
        );

      case AppRoutes.bluetoothHome:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => BluetoothHomeCubit(
              permission: BluetoothPermissionService(),
              bluetooth: BluetoothService(FlutterBluetoothSerial.instance),
            ),
            child: const BluetoothHomeScreen(),
          ),
        );

      case AppRoutes.bluetoothRemote:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => BluetoothRemoteCubit(
              bluetooth: BluetoothService(FlutterBluetoothSerial.instance),
            ),
            child: BluetoothRemoteControlScreen(device: arg as BluetoothDevice),
          ),
        );

      case AppRoutes.wifiHome:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => WifiHomeCubit(),
            child: const WifiHomeScreen(),
          ),
        );

      case AppRoutes.wifiRemote:
        return _defaultPageTransition(
          route: BlocProvider(
            create: (_) => WifiRemoteCubit(),
            child: WifiRemoteScreen(baseUrl: (arg as String)),
          ),
        );

      case AppRoutes.feedback:
        return _customPageTransition(
          route: BlocProvider(
            create: (_) => FeedbackCubit(
              feedbackService: FeedbackService(
                firestore: FirebaseFirestore.instance,
                connectivityService: ConnectivityService(),
              ),
              authService: GoogleAuthService(
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
            child: const FeedbackScreen(),
          ),
          pageTransitionBuilder: const FadeUpwardsPageTransitionsBuilder(),
        );

      case AppRoutes.biometric:
        return _defaultPageTransition(route: const BiometricAuthScreen());

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
    required super.pageBuilder,
    required this.pageTransitionsBuilder,
  });

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
