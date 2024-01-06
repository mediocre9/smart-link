part of 'bluetooth_home_cubit.dart';

sealed class BluetoothHomeState {
  const BluetoothHomeState();
}

class Initial extends BluetoothHomeState {}

class AskForPermissions extends BluetoothHomeState {
  final String message;

  AskForPermissions({required this.message});
}

class LoadDevices extends BluetoothHomeState {
  final List<BluetoothDevice> devices;

  LoadDevices({required this.devices});
}

class LoadedDevices extends BluetoothHomeState {
  final List<BluetoothDevice> devices;

  LoadedDevices({required this.devices});
}

class DeviceConnection extends BluetoothHomeState {
  final BluetoothDevice device;

  DeviceConnection({required this.device});
}
