import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_link/config/router/index.dart';
import 'package:smart_link/screens/authentication_screen/cubit/authentication_screen_cubit.dart';
import 'package:smart_link/screens/feedback_screen/cubit/feedback_cubit.dart';
import 'package:smart_link/screens/feedback_screen/feedback_screen.dart';
import 'package:smart_link/services/auth_service.dart';
import 'package:smart_link/services/bluetooth_service.dart';
import 'package:smart_link/services/feedback_service.dart';
import 'package:smart_link/services/permission_service.dart';
import '../../screens/wifi_home_screen/cubit/wifi_home_cubit.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generate(RouteSettings routeSettings) {
    var arg = routeSettings.arguments;

    switch (routeSettings.name) {
      case Routes.auth:
        return _pageTransition(
          BlocProvider(
            create: (_) => AuthenticationScreenCubit(
              authService: AuthenticationService(),
            ),
            child: const AuthenticationScreen(),
          ),
        );

      case Routes.bluetoothHome:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => BluetoothHomeCubit(
              permission: BluetoothPermissionService(),
              bluetooth: BluetoothService(FlutterBluetoothSerial.instance),
            ),
            child: const BluetoothHomeScreen(),
          ),
        );

      case Routes.bluetoothRemote:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => BluetoothRemoteCubit(),
            child: BluetoothRemoteScreen(device: (arg as BluetoothDevice)),
          ),
        );

      case Routes.wifiHome:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => WifiHomeCubit(),
            child: const WifiHomeScreen(),
          ),
        );

      case Routes.wifiRemote:
        return _pageTransition(
          BlocProvider(
            lazy: false,
            create: (_) => WifiRemoteCubit(),
            child: WifiRemoteScreen(baseUrl: (arg as String)),
          ),
        );

      case Routes.feedback:
        return _pageTransition(
          BlocProvider(
            create: (_) => FeedbackCubit(
              feedbackService: FeedbackService(firestore: FirebaseFirestore.instance),
              service: AuthenticationService(),
            ),
            child: const FeedbackScreen(),
          ),
        );

      case Routes.biometric:
        return _pageTransition(const BiometricScreen());

      default:
        return _pageTransition(_defaultRoute());
    }
  }

  static _pageTransition(Widget route) => MaterialPageRoute(builder: (_) => route);

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
