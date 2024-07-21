part of 'wifi_home_cubit.dart';

sealed class WifiHomeState {}

class Initial extends WifiHomeState {}

class Connecting extends WifiHomeState {}

class Connected extends WifiHomeState {
  final String message;

  Connected(this.message);
}

class NotConnected extends WifiHomeState {
  final String message;
  NotConnected(this.message);
}

class OnSignal extends WifiHomeState {
  final String message;
  final Color color;
  OnSignal(this.message, this.color);
}

class OffSignal extends WifiHomeState {
  final String message;
  final Color color;
  OffSignal(this.message, this.color);
}

class NetworkError extends WifiHomeState {
  final String message;
  NetworkError(this.message);
}

class BiometricError extends WifiHomeState {
  final String message;
  BiometricError(this.message);
}
