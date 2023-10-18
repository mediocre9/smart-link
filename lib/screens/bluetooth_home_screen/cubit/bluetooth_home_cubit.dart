import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../../../config/strings/strings.dart';
import '../../../services/bluetooth_service.dart';
import '../../../services/permission_service.dart';

part 'bluetooth_home_state.dart';

class BluetoothHomeCubit extends Cubit<BluetoothHomeState> {
  final BluetoothPermissionService _permission;
  final BluetoothService _bluetooth;
  final List<BluetoothDevice> _discovered = [];
  final List<BluetoothDevice> _paired = [];

  BluetoothHomeCubit(
    this._permission,
    this._bluetooth,
  ) : super(Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded)) {
    init();
  }

  Future<void> init() async {
    bool hasBluetoothPermission = await _permission.requestPermissions();
    bool? isBluetoothEnabled = await _bluetooth.enableBluetooth();

    if (hasBluetoothPermission && isBluetoothEnabled!) {
      await _getPairedDevices();
    } else {
      emit(BluetoothDisabled(message: Strings.bluetoothOff));
      emit(Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded));
    }
  }

  Future<void> startScan() async {
    bool? isBluetoothEnabled = await _bluetooth.enableBluetooth();

    if (!isBluetoothEnabled!) {
      emit(BluetoothDisabled(message: Strings.bluetoothOff));
      emit(Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded));
      return;
    }

    emit(DiscoverDevices(text: Strings.bluetoothDiscoveryDescription));
    _discovered.clear();

    await for (final result in _bluetooth.startDiscovery()) {
      _discovered.add(result.device);
    }

    if (_discovered.isNotEmpty) {
      emit(ShowDiscoveredDevices(devices: _discovered));
    } else {
      emit(HasNotFoundNewDevices(message: Strings.devicesNotInRange));
      await _getPairedDevices();
    }
  }

  Future<void> stopScan() async {
    await _bluetooth.cancelDiscovery();
    await _getPairedDevices();
  }

  Future<void> pairDevice(BluetoothDevice device) async {
    emit(PairDevice(text: 'Trying to pair with ${device.name}. Please be patient!'));
    bool? isBonded = await _bluetooth.bondDevice(device);

    if (!isBonded!) {
      emit(PairUnsuccessful(
        message: Strings.pairUnsuccessful,
        snackbarColor: Colors.deepOrange,
      ));

      emit(ShowPairedDevices(devices: _paired));
    } else {
      emit(ConnectToRemoteDevice(device: device));
    }
  }

  Future<void> _getPairedDevices() async {
    emit(GetPairedDevices(text: Strings.gettingPairedDevices));

    var devices = await _bluetooth.fetchPairedDevices();
    _paired
      ..clear()
      ..addAll(devices);

    var currentState = _paired.isNotEmpty ? ShowPairedDevices(devices: _paired) : Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded);
    emit(currentState);
  }
}
