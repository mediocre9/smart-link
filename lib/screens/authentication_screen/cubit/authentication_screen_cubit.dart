import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';
import '../../../config/index.dart';

part 'authentication_screen_state.dart';

class AuthenticationScreenCubit extends Cubit<AuthenticationScreenState> {
  final Connectivity internetConnectivity;
  final AuthenticationService authService;

  AuthenticationScreenCubit({
    required this.authService,
    required this.internetConnectivity,
  }) : super(Initial());

  Future<bool> _isInternetAvailable() async {
    var connectivityResult = await internetConnectivity.checkConnectivity();
    return (connectivityResult != ConnectivityResult.none);
  }

  Future<void> signIn() async {
    if (!await _isInternetAvailable()) {
      emit(NoInternet(message: AppStrings.noInternet));
      emit(Initial());
      return;
    }

    emit(Loading());

    SignInState state = await authService.signIn();

    switch (state) {
      case SignInState.disabled:
        emit(UserBlocked(message: AppStrings.userBlocked));
        emit(Initial());
        break;

      case SignInState.authenticated:
        emit(Authenticated(
          user: authService.getCurrentUser!,
          message: 'Signed in as ${authService.getCurrentUser!.email}',
        ));
        break;

      default:
        emit(Initial());
    }
  }
}
