part of 'bluetooth_home_cubit.dart';

sealed class BluetoothHomeState {}

class Initial extends BluetoothHomeState {
  final IconData icon;
  final String text;

  Initial({
    required this.text,
    required this.icon,
  });
}

class BluetoothDisabled extends BluetoothHomeState {
  final String message;

  BluetoothDisabled({required this.message});
}

class GrantPermissions extends BluetoothHomeState {
  final String message;

  GrantPermissions({required this.message});
}

class ScanAnimation extends BluetoothHomeState {
  final String text;
  ScanAnimation({required this.text});
}

class HasNotFoundNewDevices extends BluetoothHomeState {
  final String message;

  HasNotFoundNewDevices({required this.message});
}

class ConnectToRemoteDevice extends BluetoothHomeState {
  final BluetoothDevice device;

  ConnectToRemoteDevice({required this.device});
}

class ShowDiscoveredDevices extends BluetoothHomeState {
  final List<BluetoothDevice> devices;

  ShowDiscoveredDevices({required this.devices});
}

class PairDevice extends BluetoothHomeState {
  final String text;
  PairDevice({required this.text});
}

class PairUnsuccessful extends BluetoothHomeState {
  final String message;
  final Color snackbarColor;

  PairUnsuccessful({
    required this.snackbarColor,
    required this.message,
  });
}

class PairSuccessful extends BluetoothHomeState {
  final String message;
  final Color snackbarColor;

  PairSuccessful({
    required this.message,
    required this.snackbarColor,
  });
}

class GetPairedDevices extends BluetoothHomeState {
  final String text;
  GetPairedDevices({required this.text});
}

class ShowPairedDevices extends BluetoothHomeState {
  final List<BluetoothDevice> devices;

  ShowPairedDevices({required this.devices});
}
