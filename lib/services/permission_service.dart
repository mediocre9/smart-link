import 'package:permission_handler/permission_handler.dart';

abstract interface class IPermissionService {
  Future<bool> requestPermissions();
}

class BluetoothPermissionService implements IPermissionService {
  @override
  Future<bool> requestPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();

    return statuses.entries.map((e) => e).toList().every((element) => element.value.isGranted);
  }
}
