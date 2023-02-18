part of 'bluetooth_home_cubit.dart';

abstract class BluetoothHomeState {}

class Initial extends BluetoothHomeState {
  final IconData icon;
  final String message;

  Initial({
    required this.message,
    required this.icon,
  });
}

class DeviceHasbeenPaired extends BluetoothHomeState {
  final BluetoothDevice device;

  DeviceHasbeenPaired({required this.device});
}

class DeviceIsPairing extends BluetoothHomeState {
  final String message;
  DeviceIsPairing({required this.message});
}

class DiscoveringDevices extends BluetoothHomeState {
  final String message;
  DiscoveringDevices({required this.message});
}

class FoundedBluetoothDevices extends BluetoothHomeState {
  final List<BluetoothDevice> devices;

  final int totalDevices;

  FoundedBluetoothDevices({
    required this.totalDevices,
    required this.devices,
  });
}

class BluetoothOnGoingResponse extends BluetoothHomeState {
  final String message;

  BluetoothOnGoingResponse({required this.message});
}
