part of 'wifi_remote_cubit.dart';

abstract class WifiRemoteState {}

class Loading extends WifiRemoteState {}

class OnSignal extends WifiRemoteState {}

class OffSignal extends WifiRemoteState {}
