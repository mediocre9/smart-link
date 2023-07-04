part of 'authentication_screen_cubit.dart';

abstract class AuthenticationScreenState extends Equatable {}

class Initial extends AuthenticationScreenState {
  @override
  List<Object?> get props => [];
}

class Loading extends AuthenticationScreenState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthenticationScreenState {
  final User userCredential;

  Authenticated({required this.userCredential});

  @override
  List<Object?> get props => [userCredential];
}

class Success extends AuthenticationScreenState {
  final String message;

  Success({required this.message});

  @override
  List<Object?> get props => [message];
}

class Error extends AuthenticationScreenState {
  final String message;

  Error({required this.message});

  @override
  List<Object?> get props => [message];
}

class NoInternet extends AuthenticationScreenState {
  final String message;

  NoInternet({required this.message});

  @override
  List<Object?> get props => [message];
}
