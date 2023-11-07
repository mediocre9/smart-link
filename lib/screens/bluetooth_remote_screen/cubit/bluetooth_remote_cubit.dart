import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_link/config/strings/app_strings.dart';

part 'bluetooth_remote_state.dart';

enum RobotCommand {
  forward,
  backward,
  left,
  right,
  stop,
  cameraUp,
  cameraDown,
  cameraLeft,
  cameraRight,
  cameraStop,
}

class BluetoothRemoteCubit extends Cubit<BluetoothRemoteState> {
  BluetoothRemoteCubit() : super(BluetoothRemoteInitial());

  final Map<RobotCommand, String> _commands = {
    RobotCommand.stop: "X",
    RobotCommand.left: "L",
    RobotCommand.right: "R",
    RobotCommand.forward: "F",
    RobotCommand.backward: "B",
    RobotCommand.cameraUp: "W",
    RobotCommand.cameraStop: "0",
    RobotCommand.cameraDown: "S",
    RobotCommand.cameraLeft: "A",
    RobotCommand.cameraRight: "D",
  };

  BluetoothConnection? _bluetoothConnection;

  Future<void> connect({required BluetoothDevice device}) async {
    emit(Connecting());

    try {
      _bluetoothConnection = await BluetoothConnection.toAddress(device.address);
      emit(Connected(message: "Connected to ${device.name ?? "Unknown"}!"));
    } catch (e) {
      emit(ConnectionFailed(message: AppStrings.connectionFailed));
    }
  }

  Future<void> disconnect() async {
    await _bluetoothConnection!.finish();
    emit(Disconnected(message: AppStrings.bluetoothDisconnected));
  }

  void _sendCommand(RobotCommand command) {
    log("Robot Command: $command");
    _bluetoothConnection!.output.add(Uint8List.fromList(utf8.encode(_commands[command]!)));
  }

  void stopMovement() => _sendCommand(RobotCommand.stop);

  void moveLeft() => _sendCommand(RobotCommand.left);

  void moveRight() => _sendCommand(RobotCommand.right);

  void moveForward() => _sendCommand(RobotCommand.forward);

  void moveBackward() => _sendCommand(RobotCommand.backward);

  void stopCamera() => _sendCommand(RobotCommand.cameraStop);

  void moveCameraAngleToUp() => _sendCommand(RobotCommand.cameraUp);

  void moveCameraAngleToDown() => _sendCommand(RobotCommand.cameraDown);

  void moveCameraAngleToLeft() => _sendCommand(RobotCommand.cameraLeft);

  void moveCameraAngleToRight() => _sendCommand(RobotCommand.cameraRight);
}
