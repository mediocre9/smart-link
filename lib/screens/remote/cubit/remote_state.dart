part of 'remote_cubit.dart';

abstract class RemoteState {}

class Initial extends RemoteState {}

class Loading extends RemoteState {}

class OnSignal extends RemoteState {}

class OffSignal extends RemoteState {}

class ListenResponse extends RemoteState {
  final String message;

  ListenResponse(this.message);
}
