part of 'home_cubit.dart';

abstract class HomeState {}

class Initial extends HomeState {}

class Scanning extends HomeState {}

class DevicesFound extends HomeState {
  final List<BluetoothDevice> devices;
  final int totalFoundDevices;

  DevicesFound({
    required this.totalFoundDevices,
    required this.devices,
  });
}

class DevicesNotFound extends HomeState {
  final String message;

  DevicesNotFound({required this.message});
}

class BluetoothNotEnabled extends HomeState {
  final String message;

  BluetoothNotEnabled({required this.message});
}
