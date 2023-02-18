import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/config/app_strings.dart';

part 'bluetooth_home_state.dart';

class BluetoothHomeCubit extends Cubit<BluetoothHomeState> {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  final List<BluetoothDevice> _foundedDevices = List.empty(growable: true);
  final List<BluetoothDevice> _pairedDevices = List.empty(growable: true);

  BluetoothHomeCubit()
      : super(
          Initial(
            message: AppString.INITIAL_HOME_SCREEN,
            icon: Icons.bluetooth_rounded,
          ),
        ) {
    _getPairedDevices();
  }

  Future<bool?> get isBluetoothEnabled async => _bluetooth.isEnabled;

  int get foundedDevices => _foundedDevices.length;

  /// retrieves all paired devices.
  Future<void> _getPairedDevices() async {
    _pairedDevices.clear();
    if ((await isBluetoothEnabled)!) {
      emit(DiscoveringDevices(message: 'Getting paired devices . . .'));
      await _bluetooth
          .getBondedDevices()
          .then((paired) => _pairedDevices.addAll(paired))
          .whenComplete(() {
        if (_pairedDevices.isNotEmpty) {
          emit(FoundedBluetoothDevices(
            totalDevices: _pairedDevices.length,
            devices: _pairedDevices,
          ));
        } else {
          emit(
            Initial(
              message: AppString.INITIAL_HOME_SCREEN,
              icon: Icons.bluetooth_rounded,
            ),
          );
        }
      });
    } else {
      await _bluetooth.requestEnable().then((isBluetoothTurnedOn) {
        if (isBluetoothTurnedOn!) {
          _getPairedDevices();
        } else {
          emit(
            Initial(
              message: AppString.INITIAL_HOME_SCREEN,
              icon: Icons.bluetooth_rounded,
            ),
          );
        }
      });
    }
  }

  /// cancel discovery operation . . .
  Future<void> stopDiscovery() async {
    await _bluetooth.cancelDiscovery();
    _getPairedDevices();
  }

  /// finds nearby beacon bluetooth devices for pairing.
  Future<void> discoverDevices() async {
    if ((await isBluetoothEnabled)!) {
      emit(DiscoveringDevices(message: AppString.DISCOVERING_MSG));
      _bluetooth.startDiscovery().listen((e) {
        _foundedDevices.clear();
        _foundedDevices.add(e.device);
      }).onDone(() {
        if (_foundedDevices.isNotEmpty) {
          emit(FoundedBluetoothDevices(
            totalDevices: _foundedDevices.length,
            devices: _foundedDevices,
          ));
          return;
        } else if (_pairedDevices.isNotEmpty) {
          emit(BluetoothOnGoingResponse(
              message: AppString.UNDISCOVERED_DEVICES_MSG));
          emit(FoundedBluetoothDevices(
            totalDevices: _pairedDevices.length,
            devices: _pairedDevices,
          ));

          return;
        } else {
          emit(BluetoothOnGoingResponse(
              message: AppString.UNDISCOVERED_DEVICES_MSG));
          emit(
            Initial(
              message: AppString.INITIAL_HOME_SCREEN,
              icon: Icons.bluetooth_rounded,
            ),
          );
        }
      });
    } else {
      await _bluetooth.requestEnable().then((isBluetoothTurnedOn) {
        if (isBluetoothTurnedOn!) {
          _getPairedDevices();
        } else {
          emit(BluetoothOnGoingResponse(
              message: AppString.DISABLED_BLUETOOTH_MSG));
          emit(
            Initial(
              message: AppString.INITIAL_HOME_SCREEN,
              icon: Icons.bluetooth_rounded,
            ),
          );
        }
      });
    }
  }

  /// Tries to pair with discovered unpaired device.
  Future<void> pairDevice(BluetoothDevice device) async {
    if (!device.isBonded) {
      emit(DeviceIsPairing(
          message: 'Trying to pair with ${device.name}. Please be patient!'));
      await _bluetooth.bondDeviceAtAddress(device.address).then((connState) {
        if (connState!) {
          device;
          emit(BluetoothOnGoingResponse(message: 'Paired to ${device.name}!'));
          emit(DeviceHasbeenPaired(device: device));
        } else {
          emit(BluetoothOnGoingResponse(
              message: 'Couldn`t pair with ${device.name}!'));
          emit(FoundedBluetoothDevices(
            totalDevices: _foundedDevices.length,
            devices: _foundedDevices,
          ));
        }
      });
    } else if (device.isBonded) {
      emit(DeviceHasbeenPaired(device: device));
    }
  }
}
