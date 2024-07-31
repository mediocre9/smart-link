part of 'wifi_home_cubit.dart';

sealed class WifiHomeState {}

class Initial extends WifiHomeState {}

class Connecting extends WifiHomeState {}

class NotConnected extends WifiHomeState {
  final String message;
  NotConnected(this.message);
}

class Unlock extends WifiHomeState {
  final String message;
  Unlock(this.message);
}

class NetworkError extends WifiHomeState {
  final String message;
  NetworkError(this.message);
}

class BiometricError extends WifiHomeState {
  final String message;
  BiometricError(this.message);
}
