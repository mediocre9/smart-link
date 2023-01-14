import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../auth/google_auth.dart';
part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();
  SignInCubit() : super(Initial()) {
    _googleAuthentication.getFirebaseAuthInstance!.authStateChanges().listen(
      (event) async {
        if (event != null) {
          await signIn();
        }
      },
    ).cancel();
  }

  Future<void> signIn() async {
    try {
      emit(Loading());
      bool hasSignedUpSuccessfully = await _googleAuthentication.signUp();

      if (!hasSignedUpSuccessfully) {
        emit(Initial());
        return;
      }

      emit(Success(message: "Successfully logged in!"));
      emit(
        Authenticated(userCredential: _googleAuthentication.getUserCredential!),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        emit(Error(message: "Your account has been suspended!"));
        emit(Initial());
        return;
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _googleAuthentication.logOut();
    } catch (e) {}
  }
}
