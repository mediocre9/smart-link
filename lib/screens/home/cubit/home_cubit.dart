import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/config/app_strings.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  final List<BluetoothDevice> _foundedDevices = [];
  BluetoothDevice? _connectedDevice;
  HomeCubit() : super(Initial()) {
    getPairedDevices();
  }

  Future<bool?> get isBluetoothEnabled async => _bluetooth.isEnabled;

  Future establishConnectionToDevice(BluetoothDevice device) async {
    if (!device.isBonded) {
      emit(Loading(message: 'Connecting to ${device.name} . . .'));
      await _bluetooth.bondDeviceAtAddress(device.address).then((connState) {
        if (connState!) {
          _connectedDevice = device;
          emit(BluetoothResponse(message: 'Connected to ${device.name}!'));
          emit(Connected());
        } else {
          emit(BluetoothResponse(
              message: 'Couldn`t connect to ${device.name}!'));
          emit(ShowDevices(
            totalDevices: _foundedDevices.length,
            devices: _foundedDevices,
          ));
        }
      });
    }
  }

  Future unPairDevice(BluetoothDevice device) async {
    _foundedDevices.removeWhere((element) => element.address == device.address);
    if (device.isBonded) {
      await _bluetooth
          .removeDeviceBondWithAddress(device.address)
          .then((isUnPairSucessful) {
        if (isUnPairSucessful!) {
          emit(BluetoothResponse(
              message: 'Device ${device.name} has been unpaired!'));
        }
      });
    }
  }

  Future getPairedDevices() async {
    if ((await isBluetoothEnabled)!) {
      _foundedDevices.clear();
      emit(Loading(message: 'Getting paired devices . . .'));
      await _bluetooth
          .getBondedDevices()
          .then((paired) => _foundedDevices.addAll(paired))
          .whenComplete(() {
        if (_foundedDevices.isNotEmpty) {
          emit(ShowDevices(
            totalDevices: _foundedDevices.length,
            devices: _foundedDevices,
          ));
        } else {
          discoverDevices();
        }
      });
    } else {
      await _bluetooth.requestEnable();
      emit(BluetoothResponse(message: AppString.BLUE_TOOTH_SERVICE_MSG));
    }
  }

  Future discoverDevices() async {
    if ((await isBluetoothEnabled)!) {
      _foundedDevices.clear();
      emit(Loading(message: AppString.ON_SCAN_MSG));
      _bluetooth.startDiscovery().listen((e) {
        _foundedDevices.add(e.device);
      }).onDone(() {
        if (_foundedDevices.isNotEmpty) {
          emit(ShowDevices(
            totalDevices: _foundedDevices.length,
            devices: _foundedDevices,
          ));
        } else {
          emit(BluetoothResponse(message: AppString.DEVICES_NOT_FOUND));
        }
      });
    } else {
      await _bluetooth.requestEnable();
      emit(BluetoothResponse(message: AppString.BLUE_TOOTH_SERVICE_MSG));
    }
  }

  Future onMessage() async {
    emit(Loading(message: 'Sending 1-bit status signal. . .'));
    BluetoothConnection con =
        await BluetoothConnection.toAddress(_connectedDevice!.address);
    con.output.add(Uint8List.fromList(utf8.encode('1')));
    emit(BluetoothResponse(message: '1-bit status signal!'));
  }

  Future offMessage() async {
    emit(Loading(message: 'Sending 1-bit status signal. . .'));
    BluetoothConnection con =
        await BluetoothConnection.toAddress(_connectedDevice!.address);
    con.output.add(Uint8List.fromList(utf8.encode('0')));
    emit(BluetoothResponse(message: '0-bit status signal!'));
  }
}
