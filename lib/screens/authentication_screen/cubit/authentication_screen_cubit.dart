import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_link/services/services.dart';
import 'package:smart_link/config/config.dart';

part 'authentication_screen_state.dart';

class AuthenticationScreenCubit extends Cubit<AuthenticationScreenState> {
  final IConnectivityService connectivityService;
  final GoogleAuthService authService;

  AuthenticationScreenCubit({
    required this.authService,
    required this.connectivityService,
  }) : super(Initial());

  Future<void> signIn() async {
    if (await connectivityService.isOffline()) {
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

      case SignInState.error:
        emit(NoInternet(
          message:
              'Something went wrong. Please check your internet connection.',
        ));
        emit(Initial());
        break;

      default:
        emit(Initial());
        break;
    }
  }
}
