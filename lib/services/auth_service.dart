import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum SignInState {
  authenticated,
  disabled,
  error,
}

abstract interface class IAuthenticationService {
  Future<SignInState> signIn();
}

class GoogleAuthService implements IAuthenticationService {
  final FirebaseAuth firebaseAuth;

  GoogleAuthService({required this.firebaseAuth});

  User? get getCurrentUser => firebaseAuth.currentUser;

  OAuthCredential _getOAuthCredential(GoogleSignInAuthentication? auth) {
    return GoogleAuthProvider.credential(
      idToken: auth?.idToken,
      accessToken: auth?.accessToken,
    );
  }

  @override
  Future<SignInState> signIn() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? user = await googleSignIn.signIn();

      GoogleSignInAuthentication? auth = await user?.authentication;
      AuthCredential credential = _getOAuthCredential(auth);

      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      if (e.code == "user-disabled") {
        return SignInState.disabled;
      }
    } catch (e) {
      log('SignStateError: ${e.toString()}');
      return SignInState.error;
    }
    return SignInState.authenticated;
  }
}
