import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';
import '../../../config/index.dart';

part 'authentication_screen_state.dart';

class AuthenticationScreenCubit extends Cubit<AuthenticationScreenState> {
  late ConnectivityResult _connectivityResult;
  final AuthenticationService authService;

  AuthenticationScreenCubit({required this.authService}) : super(Initial());

  Future<bool> _isInternetAvailable() async {
    _connectivityResult = await Connectivity().checkConnectivity();

    if (_connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  Future<void> signIn() async {
    if (!await _isInternetAvailable()) {
      emit(NoInternet(message: Strings.noInternet));
      emit(Initial());
    } else {
      emit(Loading());

      SignInState state = await authService.signIn();

      switch (state) {
        case SignInState.disabled:
          emit(UserBlocked(message: Strings.userBlocked));
          emit(Initial());
          break;
        default:
          emit(Authenticated(
            user: authService.getCurrentUser!,
            message: 'Signed in as ${authService.getCurrentUser!.email}',
          ));
      }
    }
  }
}
