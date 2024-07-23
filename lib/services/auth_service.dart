import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_link/config/router/routes.dart';

enum SignInState {
  authenticated,
  disabled,
  error,
}

abstract interface class IAuthenticationService {
  Future<SignInState> signIn();
  Future<bool> isRevoked();
}

class GoogleAuthService implements IAuthenticationService {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final IConnectivityService _connectivityService = ConnectivityService();

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
      GoogleSignInAccount? user = await _googleSignIn.signIn();
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

  @override
  Future<bool> isRevoked() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return true;
      }

      if (await _connectivityService.isOffline()) {
        return false;
      }

      IdTokenResult result = await user.getIdTokenResult(true);
      return result.token == null;
    } on Exception catch (e) {
      log(e.toString());
      return true;
    }
  }
}
