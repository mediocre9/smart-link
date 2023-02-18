// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'bluetooth_remote_state.dart';

class BluetoothRemoteCubit extends Cubit<BluetoothRemoteState> {
  BluetoothRemoteCubit() : super(ConnectedToBluetoothDevice());
  static const String FORWARD = 'F';
  static const String BACKWARD = 'B';
  static const String LEFT = 'L';
  static const String RIGHT = 'R';
  static const String STOP = 'X';

  static const String CAMERA_ANGLE_UP = 'W';
  static const String CAMERA_ANGLE_DOWN = 'S';
  static const String CAMERA_ANGLE_LEFT = 'A';
  static const String CAMERA_ANGLE_RIGHT = 'D';
  static const String CAMERA_STOP = '0';

  BluetoothDevice? device;
  BluetoothConnection? _connection;

  Future<void> connect(BluetoothDevice device) async {
    emit(EstablishingBluetoothConnection());

    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      emit(ConnectionStatus(message: "Connected!"));
      emit(ConnectedToBluetoothDevice());
    } catch (e) {
      emit(ConnectionStatus(message: "End device not responding!"));
    }
  }

  void disconnectOnGoingConnection() async {
    await _connection!.finish();
    emit(ConnectionStatus(message: "Disconnected!"));
  }

  void reset() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(STOP)));
  }

  void moveForward() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(FORWARD)));
  }

  void moveBackward() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(BACKWARD)));
  }

  void moveLeft() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(LEFT)));
  }

  void moveRight() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(RIGHT)));
  }

  // w / s / d / a
  void moveCameraAngleToUp() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(CAMERA_ANGLE_UP)));
  }

  void moveCameraAngleToDown() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(CAMERA_ANGLE_DOWN)));
  }

  void moveCameraAngleToRight() {
    _connection!.output
        .add(Uint8List.fromList(utf8.encode(CAMERA_ANGLE_RIGHT)));
  }

  void moveCameraAngleToLeft() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(CAMERA_ANGLE_LEFT)));
  }

  void stopCamera() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(CAMERA_STOP)));
  }
}
