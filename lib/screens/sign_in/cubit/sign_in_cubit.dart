import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:remo_tooth/config/app_strings.dart';

import '../../../auth/google_auth.dart';
part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();
  late ConnectivityResult _connectivityResult;

  SignInCubit() : super(Initial()) {
    _googleAuthentication.getFirebaseAuthInstance!.authStateChanges().listen(
      (event) async {
        if (event != null) {
          Authenticated(
            userCredential: _googleAuthentication.getUserCredential!,
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
      try {
        emit(Loading());
        bool hasSignedUpSuccessfully = await _googleAuthentication.signUp();

        if (!hasSignedUpSuccessfully) {
          emit(Initial());
          return;
        }

        emit(
          Success(
            message:
                'Signed in as ${_googleAuthentication.getUserCredential!.email}',
          ),
        );
        emit(
          Authenticated(
              userCredential: _googleAuthentication.getUserCredential!),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-disabled') {
          emit(Error(message: AppString.SUSPEND_MSG));
          emit(Initial());
          return;
        }
      }
    } else {
      emit(NoInternet(message: AppString.NO_INTERNET_MSG));
      emit(Initial());
    }
  }

  Future<void> signOut() async {
    try {
      await _googleAuthentication.logOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
