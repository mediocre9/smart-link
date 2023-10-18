import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract interface class IBluetoothService {
  Stream<BluetoothDiscoveryResult> startDiscovery();

  Future<List<BluetoothDevice>> fetchPairedDevices();

  Future<bool?> enableBluetooth();

  Future<bool?> bondDevice(BluetoothDevice device);

  Future<void> cancelDiscovery();
}

class BluetoothService implements IBluetoothService {
  final FlutterBluetoothSerial _bluetooth;

  BluetoothService(this._bluetooth);

  @override
  Stream<BluetoothDiscoveryResult> startDiscovery() {
    return _bluetooth.startDiscovery();
  }

  @override
  Future<void> cancelDiscovery() async {
    await _bluetooth.cancelDiscovery();
  }

  @override
  Future<List<BluetoothDevice>> fetchPairedDevices() async {
    return await _bluetooth.getBondedDevices();
  }

  @override
  Future<bool?> bondDevice(BluetoothDevice device) async {
    return device.isBonded ? true : await _bluetooth.bondDeviceAtAddress(device.address);
  }

  @override
  Future<bool?> enableBluetooth() async {
    return await _bluetooth.requestEnable();
  }
}
