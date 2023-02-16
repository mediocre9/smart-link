part of 'home_cubit.dart';

abstract class HomeState {}

class Initial extends HomeState {
  final String message;
  Initial({required this.message});
}

class Paired extends HomeState {
  final BluetoothDevice device;

  Paired({required this.device});
}

class Pairing extends HomeState {
  final String message;
  Pairing({required this.message});
}

class Discovering extends HomeState {
  final String message;
  Discovering({required this.message});
}

class ShowDevices extends HomeState {
  final List<BluetoothDevice> devices;

  final int totalDevices;

  ShowDevices({
    required this.totalDevices,
    required this.devices,
  });
}

class BluetoothResponse extends HomeState {
  final String message;

  BluetoothResponse({required this.message});
}
