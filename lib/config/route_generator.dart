import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remo_tooth/screens/home/cubit/home_cubit.dart';
import 'package:remo_tooth/screens/sign_in/cubit/sign_in_cubit.dart';
import '../screens/sign_in/sign_in_screen.dart';
import 'app_routes.dart';
import '../screens/home/home_screen.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generate(RouteSettings routeSettings) {
    var arg = routeSettings.arguments;
    switch (routeSettings.name) {
      case AppRoute.HOME:
        return _pageTransition(
          MultiBlocProvider(
            providers: [
              BlocProvider(lazy: false, create: (_) => SignInCubit()),
              BlocProvider(lazy: false, create: (_) => HomeCubit()),
            ],
            child: HomeScreen(userCredential: (arg as User)),
          ),
        );

      case AppRoute.SIGN_UP:
        return _pageTransition(
          BlocProvider(
            create: (_) => SignInCubit(),
            child: const SignInScreen(),
          ),
        );

      default:
        return _pageTransition(_defaultRoute());
    }
  }

  static _pageTransition(Widget route) =>
      MaterialPageRoute(builder: (_) => route);

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
