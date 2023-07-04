import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';
import '../../../config/index.dart';

part 'authentication_screen_state.dart';

class AuthenticationScreenCubit extends Cubit<AuthenticationScreenState> {
  late ConnectivityResult _connectivityResult;

  AuthenticationScreenCubit() : super(Initial()) {
    AuthService.getFirebaseAuthInstance!.authStateChanges().listen(
      (event) async {
        if (event != null) {
          Authenticated(
            userCredential: AuthService.getCurrentUser!,
          );
        }
      },
    );
  }

  Future<bool> _isInternetAvailable() async {
    _connectivityResult = await Connectivity().checkConnectivity();

    if (_connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  Future<void> signIn() async {
    if (await _isInternetAvailable()) {
      emit(Loading());

      SignInState state = await AuthService.signUp();
      switch (state) {
        case SignInState.notFound:
        case SignInState.disabled:
          emit(Error(message: AppString.kAuthSuspendMessage));
          emit(Initial());
          break;
        default:
          emit(
            Success(
              message: 'Signed in as ${AuthService.getCurrentUser!.email}',
            ),
          );
          emit(
            Authenticated(userCredential: AuthService.getCurrentUser!),
          );
      }
    } else {
      emit(NoInternet(message: AppString.kNoInternetMessage));
      emit(Initial());
    }
  }

  Future<void> signOut() async {
    try {
      await AuthService.logOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
