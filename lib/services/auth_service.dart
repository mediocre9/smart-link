import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum SignInState {
  authenticated,
  disabled,
}

abstract interface class IAuthenticationService {
  Future<SignInState> signIn();
}

class AuthenticationService implements IAuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get getCurrentUser => _auth.currentUser;

  @override
  Future<SignInState> signIn() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? user = await googleSignIn.signIn();

      if (user != null) {
        GoogleSignInAuthentication auth = await user.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: auth.idToken,
          accessToken: auth.accessToken,
        );

        await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      if (e.code == 'user-disabled') {
        return SignInState.disabled;
      }
    }
    return SignInState.authenticated;
  }
}
