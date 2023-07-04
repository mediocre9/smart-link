import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum SignInState {
  authenticated,
  disabled,
  notFound,
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Returns currently signed up user credentials.
  static User? get getCurrentUser => _auth.currentUser;

  /// Returns an instance of `FirebaseAuth`.
  static FirebaseAuth? get getFirebaseAuthInstance => _auth;

  static Future<User?> logOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      log(e.message!);
    }
    return getCurrentUser;
  }

  static Future<SignInState> signUp() async {
    try {
      GoogleSignInAccount? user = await _googleSignIn.signIn();

      if (user != null) {
        GoogleSignInAuthentication auth = await user.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: auth.idToken,
          accessToken: auth.accessToken,
        );

        await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-disabled':
          return SignInState.disabled;
        case 'user-not-found':
          return SignInState.notFound;
      }
    }
    return SignInState.authenticated;
  }
}
