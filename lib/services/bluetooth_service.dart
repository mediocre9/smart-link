import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract interface class IBluetoothService {
  Future<bool?> isEnabled();

  Future<void> cancelDiscovery();

  Future<bool?> enableBluetoothAdapter();

  Stream<BluetoothState> onAdapterStateChanges();

  Future<List<BluetoothDevice>> getPairedDevices();

  Stream<BluetoothDiscoveryResult> startDiscovery();

  Future<bool?> bondDevice(BluetoothDevice device);

  Future<BluetoothConnection> establishConnectionTo(BluetoothDevice device);
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
  Future<List<BluetoothDevice>> getPairedDevices() async {
    return await _bluetooth.getBondedDevices();
  }

  @override
  Future<bool?> enableBluetoothAdapter() async {
    return await _bluetooth.requestEnable();
  }

  @override
  Future<bool?> isEnabled() {
    return _bluetooth.isEnabled;
  }

  @override
  Stream<BluetoothState> onAdapterStateChanges() {
    return _bluetooth.onStateChanged();
  }

  @override
  Future<bool?> bondDevice(BluetoothDevice device) async {
    return await _bluetooth.bondDeviceAtAddress(device.address);
  }

  @override
  Future<BluetoothConnection> establishConnectionTo(BluetoothDevice device) {
    return BluetoothConnection.toAddress(device.address);
  }
}
