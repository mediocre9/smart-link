part of 'sign_in_cubit.dart';

abstract class SignInState extends Equatable {}

class Initial extends SignInState {
  @override
  List<Object?> get props => [];
}

class Loading extends SignInState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends SignInState {
  final User userCredential;

  Authenticated({required this.userCredential});

  @override
  List<Object?> get props => [userCredential];
}

class Success extends SignInState {
  final String message;

  Success({required this.message});

  @override
  List<Object?> get props => [message];
}

class Error extends SignInState {
  final String message;

  Error({required this.message});

  @override
  List<Object?> get props => [message];
}

class NoInternet extends SignInState {
  final String message;

  NoInternet({required this.message});

  @override
  List<Object?> get props => [message];
}
