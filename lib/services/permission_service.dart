import 'package:permission_handler/permission_handler.dart';

abstract interface class IPermissionService {
  Future<bool> requestPermissions();
}

class BluetoothPermissionService implements IPermissionService {
  @override
  Future<bool> requestPermissions() async {
    final Map<Permission, PermissionStatus> permissions = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();

    return permissions.values.every((element) => element.isGranted);
  }
}
