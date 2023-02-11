// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'remote_state.dart';

class RemoteCubit extends Cubit<RemoteState> {
  RemoteCubit() : super(Initial());
  static const Color SELECTED_BUTTON_COLOR = Colors.blue;
  static const String FORWARD = 'F';
  static const String BACKWARD = 'B';
  static const String LEFT = 'L';
  static const String RIGHT = 'R';
  static const String RESET = 'X';

  static const String CAMERA_ANGLE_UP = 'W';
  static const String CAMERA_ANGLE_DOWN = 'S';
  static const String CAMERA_ANGLE_LEFT = 'D';
  static const String CAMERA_ANGLE_RIGHT = 'A';

  BluetoothDevice? device;
  BluetoothConnection? _connection;

  Future<void> connect(BluetoothDevice device) async {
    emit(Loading());
    _connection = await BluetoothConnection.toAddress(device.address);
    emit(Initial());
  }

  void reset() {
    _connection!.output.add(Uint8List.fromList(utf8.encode(RESET)));
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
}
