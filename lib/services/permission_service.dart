import 'package:permission_handler/permission_handler.dart';

abstract interface class IPermissionService {
  Future<bool> requestPermissions();
}

class BluetoothPermissionService implements IPermissionService {
  @override
  Future<bool> requestPermissions() async {
    List<PermissionStatus> permissions = await Future.wait([
      Permission.bluetoothConnect.request(),
      Permission.bluetoothScan.request(),
      Permission.location.request(),
    ]);

    return permissions.every((permission) => permission.isGranted);
  }
}
