part of 'remote_cubit.dart';

abstract class RemoteState {}

class Initial extends RemoteState {
  final bool? status;
  final String? message;
  Initial({this.status, this.message});
}

class Loading extends RemoteState {}
