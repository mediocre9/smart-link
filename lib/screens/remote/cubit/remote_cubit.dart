// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'remote_state.dart';

class RemoteCubit extends Cubit<RemoteState> {
  RemoteCubit() : super(Initial(status: false, message: 'WAITING'));

  static const String FORWARD = 'F';
  static const String BACKWARD = 'B';
  static const String LEFT = 'L';
  static const String RIGHT = 'R';

  BluetoothDevice? device;
  BluetoothConnection? _connection;

  Future<void> connect(BluetoothDevice device) async {
    emit(Loading());
    _connection = await BluetoothConnection.toAddress(device.address);
    emit(Initial(status: _connection!.isConnected, message: 'WAITING'));
  }

  void moveForward() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(FORWARD)));
    emit(Initial(status: _connection!.isConnected, message: FORWARD));
  }

  void moveBackward() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(BACKWARD)));
    emit(Initial(status: _connection!.isConnected, message: BACKWARD));
  }

  void moveLeft() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(LEFT)));
    emit(Initial(status: _connection!.isConnected, message: LEFT));
  }

  void moveRight() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(RIGHT)));
    emit(Initial(status: _connection!.isConnected, message: RIGHT));
  }
}
