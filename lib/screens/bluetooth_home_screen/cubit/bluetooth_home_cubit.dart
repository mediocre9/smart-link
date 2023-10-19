import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../config/strings/strings.dart';

part 'bluetooth_home_state.dart';

class BluetoothHomeCubit extends Cubit<BluetoothHomeState> {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  final List<BluetoothDevice> _foundedDevices = [];
  final List<BluetoothDevice> _pairedDevices = [];

  BluetoothHomeCubit()
      : super(
          Initial(
            text: Strings.bluetoothOnHomeDescription,
            icon: Icons.bluetooth_rounded,
          ),
        ) {
    _grantPermissions();
  }

  Future<void> _grantPermissions() async {
    PermissionStatus connectStatus =
        await Permission.bluetoothConnect.request();
    PermissionStatus scanStatus = await Permission.bluetoothScan.request();

    if (connectStatus.isGranted && scanStatus.isGranted) {
      await _getPairedDevices();
    } else {
      emit(BluetoothDisabled(message: Strings.bluetoothOff));
    }
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
              text: Strings.bluetoothOnHomeDescription,
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
              text: Strings.bluetoothOnHomeDescription,
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
      emit(DiscoverNewDevices(text: Strings.bluetoothDiscoveryDescription));
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
          emit(HasNotFoundNewDevices(message: Strings.devicesNotInRange));
          emit(ShowPairedDevices(
            totalPairedDevices: _pairedDevices.length,
            pairedDevices: _pairedDevices,
          ));
          return;
        } else {
          emit(HasNotFoundNewDevices(message: Strings.devicesNotInRange));
          emit(
            Initial(
              text: Strings.bluetoothOnHomeDescription,
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
          emit(BluetoothDisabled(message: Strings.bluetoothOff));
          emit(Initial(
            text: Strings.bluetoothOnHomeDescription,
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
