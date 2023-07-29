part of 'authentication_screen_cubit.dart';

sealed class AuthenticationScreenState extends Equatable {}

class Initial extends AuthenticationScreenState {
  @override
  List<Object?> get props => [];
}

class Loading extends AuthenticationScreenState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthenticationScreenState {
  final User user;
  final String message;
  Authenticated({required this.message, required this.user});

  @override
  List<Object?> get props => [user, message];
}

class UserBlocked extends AuthenticationScreenState {
  final String message;

  UserBlocked({required this.message});

  @override
  List<Object?> get props => [message];
}

class NoInternet extends AuthenticationScreenState {
  final String message;

  NoInternet({required this.message});

  @override
  List<Object?> get props => [message];
}
