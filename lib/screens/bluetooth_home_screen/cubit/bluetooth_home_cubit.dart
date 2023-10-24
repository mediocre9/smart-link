import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../config/strings/strings.dart';
import '../../../services/bluetooth_service.dart';
import '../../../services/permission_service.dart';

part 'bluetooth_home_state.dart';

class BluetoothHomeCubit extends Cubit<BluetoothHomeState> {
  final BluetoothPermissionService permission;
  final BluetoothService bluetooth;
  final List<BluetoothDevice> _discovered = [];
  final List<BluetoothDevice> _paired = [];

  BluetoothHomeCubit({
    required this.permission,
    required this.bluetooth,
  }) : super(Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded)) {
    _init();
  }

  Future<void> _init() async {
    bool hasPermissions = await permission.requestPermissions();

    if (!hasPermissions) {
      emit(GrantPermissions(message: Strings.permissionInfo));
      emit(Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded));
      return;
    }

    bool? isEnabled = await bluetooth.enableBluetooth();

    if (!isEnabled!) {
      emit(BluetoothDisabled(message: Strings.bluetoothOff));
      emit(Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded));
      return;
    }

    await _getPairedDevices();
  }

  Future<void> startScan() async {
    bool hasPermissions = await permission.requestPermissions();

    if (!hasPermissions) {
      emit(GrantPermissions(message: Strings.permissionInfo));
      emit(Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded));
      return;
    }

    bool? isEnabled = await bluetooth.enableBluetooth();

    if (!isEnabled!) {
      emit(BluetoothDisabled(message: Strings.bluetoothOff));
      emit(Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded));

      return;
    }

    emit(ScanAnimation(text: Strings.bluetoothDiscoveryDescription));

    _discovered.clear();

    await for (final result in bluetooth.startDiscovery()) {
      _discovered.add(result.device);
    }

    if (_discovered.isNotEmpty) {
      emit(ShowDiscoveredDevices(devices: _discovered));
    } else {
      emit(HasNotFoundNewDevices(message: Strings.devicesNotInRange));
      await _getPairedDevices();
    }
  }

  Future<void> openSettings() async => await openAppSettings();

  Future<void> stopScan() async {
    await bluetooth.cancelDiscovery();
    await _getPairedDevices();
  }

  Future<void> pairDevice(BluetoothDevice device) async {
    emit(PairDevice(text: 'Trying to pair with ${device.name}. Please be patient!'));
    bool? isBonded = await bluetooth.bondDevice(device);

    if (!isBonded!) {
      emit(PairUnsuccessful(
        message: "Couldn't pair with ${device.name}",
        snackbarColor: Colors.deepOrange,
      ));

      emit(ShowPairedDevices(devices: _paired));
    } else {
      emit(ConnectToRemoteDevice(device: device));
    }
  }

  Future<void> _getPairedDevices() async {
    emit(GetPairedDevices(text: Strings.gettingPairedDevices));

    final List<BluetoothDevice> devices = await bluetooth.fetchPairedDevices();
    _paired
      ..clear()
      ..addAll(devices);

    final currentState = _paired.isNotEmpty ? ShowPairedDevices(devices: _paired) : Initial(text: Strings.bluetoothOnHomeDescription, icon: Icons.bluetooth_rounded);
    emit(currentState);
  }
}
