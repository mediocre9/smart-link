part of 'home_cubit.dart';

abstract class HomeState {}

class Initial extends HomeState {}

class Connected extends HomeState {}

class Loading extends HomeState {
  final String message;
  Loading({required this.message});
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
