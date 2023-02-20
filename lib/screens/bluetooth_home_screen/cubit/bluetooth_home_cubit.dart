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
            text: AppString.INITIAL_HOME_SCREEN,
            icon: Icons.bluetooth_rounded,
          ),
        ) {
    _getPairedDevices();
  }

  Future<bool?> get isBluetoothEnabled async => _bluetooth.isEnabled;

  /// retrieves all paired devices.
  Future<void> _getPairedDevices() async {
    _pairedDevices.clear();
    if ((await isBluetoothEnabled)!) {
      emit(GetPairedDevices(text: 'Getting paired devices . . .'));
      await _bluetooth
          .getBondedDevices()
          .then((paired) => _pairedDevices.addAll(paired))
          .whenComplete(() {
        if (_pairedDevices.isNotEmpty) {
          emit(ShowPairedDevices(
            totalPairedDevices: _pairedDevices.length,
            pairedDevices: _pairedDevices,
          ));
        } else {
          emit(
            Initial(
              text: AppString.INITIAL_HOME_SCREEN,
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
              text: AppString.INITIAL_HOME_SCREEN,
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
    _foundedDevices.clear();
    if ((await isBluetoothEnabled)!) {
      emit(DiscoverNewDevices(text: AppString.DISCOVERING_MSG));
      _bluetooth.startDiscovery().listen((e) {
        _foundedDevices
          ..clear()
          ..add(e.device);
      }).onDone(() {
        if (_foundedDevices.isNotEmpty) {
          emit(ShowDiscoveredDevices(
            totalDiscoveredDevices: _foundedDevices.length,
            discoveredDevices: _foundedDevices,
          ));
          return;
        } else if (_pairedDevices.isNotEmpty) {
          emit(HasNotFoundNewDevices(
              message: AppString.UNDISCOVERED_DEVICES_MSG));
          emit(ShowPairedDevices(
            totalPairedDevices: _pairedDevices.length,
            pairedDevices: _pairedDevices,
          ));
          return;
        } else {
          emit(HasNotFoundNewDevices(
              message: AppString.UNDISCOVERED_DEVICES_MSG));
          emit(
            Initial(
              text: AppString.INITIAL_HOME_SCREEN,
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
          emit(BluetoothDisabled(message: AppString.DISABLED_BLUETOOTH_MSG));
          emit(Initial(
            text: AppString.INITIAL_HOME_SCREEN,
            icon: Icons.bluetooth_rounded,
          ));
        }
      });
    }
  }

  /// Tries to pair with discovered unpaired device.
  Future<void> pairDevice(BluetoothDevice device) async {
    if (!device.isBonded) {
      emit(PairDevice(
        text: 'Trying to pair with ${device.name}. Please be patient!',
      ));

      await _bluetooth.bondDeviceAtAddress(device.address).then((connState) {
        if (connState!) {
          device;
          emit(PairSuccessful(
            message: 'Paired to ${device.name}!',
            snackbarColor: Colors.green,
          ));
          emit(ConnectToRemoteDevice(device: device));
        } else {
          emit(PairUnsuccessful(
            message: 'Couldn`t pair with ${device.name}!',
            snackbarColor: Colors.deepOrange,
          ));
          emit(ShowPairedDevices(
            totalPairedDevices: _foundedDevices.length,
            pairedDevices: _foundedDevices,
          ));
        }
      });
    } else {
      emit(ConnectToRemoteDevice(device: device));
    }
  }
}
