part of 'bluetooth_remote_cubit.dart';

abstract class BluetoothRemoteState {}

class ConnectedToBluetoothDevice extends BluetoothRemoteState {}

class EstablishingBluetoothConnection extends BluetoothRemoteState {}

class ConnectionStatus extends BluetoothRemoteState {
  final String message;
  ConnectionStatus({required this.message});
}
