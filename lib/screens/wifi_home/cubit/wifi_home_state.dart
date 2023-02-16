part of 'wifi_home_cubit.dart';

abstract class WifiHomeState {}

class Initial extends WifiHomeState {}

class Connecting extends WifiHomeState {}

class Connected extends WifiHomeState {
  final String baseUrl;

  Connected(this.baseUrl);
}

class NotConnected extends WifiHomeState {
  final String message;
  NotConnected(this.message);
}
