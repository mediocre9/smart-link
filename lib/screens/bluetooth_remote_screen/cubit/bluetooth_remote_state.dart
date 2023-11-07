part of 'bluetooth_remote_cubit.dart';

abstract class BluetoothRemoteState {}

class BluetoothRemoteInitial extends BluetoothRemoteState {}

class Connected extends BluetoothRemoteState {
  final String message;

  Connected({required this.message});
}

class Connecting extends BluetoothRemoteState {}

class ConnectionFailed extends BluetoothRemoteState {
  final String message;
  ConnectionFailed({required this.message});
}

class Disconnected extends BluetoothRemoteState {
  final String message;
  Disconnected({required this.message});
}
