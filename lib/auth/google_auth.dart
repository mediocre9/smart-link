import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth.dart';

class GoogleAuthentication implements Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _hasSignedUp = false;
  bool _hasLoggedOut = false;

  /// Returns currenly signed up user credentials.
  User? get getUserCredential => _firebaseAuth.currentUser!;

  /// Returns an instance of `FirebaseAuth`.
  FirebaseAuth? get getFirebaseAuthInstance => _firebaseAuth;

  @override
  Future<bool> logOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      _hasLoggedOut = true;
    } on FirebaseAuthException catch (e) {
      log(e.message!);
    }
    return _hasLoggedOut;
  }

  @override
  Future<bool> signUp() async {
    try {
      GoogleSignInAccount? userAccount = await _googleSignIn.signIn();

      if (userAccount != null) {
        GoogleSignInAuthentication signInAuth =
            await userAccount.authentication;

        AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
          idToken: signInAuth.idToken,
          accessToken: signInAuth.accessToken,
        );

        await _firebaseAuth.signInWithCredential(googleAuthCredential);
        _hasSignedUp = true;
      }
    } catch (e) {
      rethrow;
    }
    return _hasSignedUp;
  }
}
