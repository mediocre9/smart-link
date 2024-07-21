import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/extensions.dart';
import 'package:smart_link/services/services.dart';

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
  final IBluetoothService bluetooth;
  BluetoothConnection? _bluetoothConnection;
  late SharedPreferences _prefs;

  final Map<RobotCommand, String> _defaultCommands = {
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

  final Map<RobotCommand, String> _commands = {};

  BluetoothRemoteCubit({required this.bluetooth})
      : super(BluetoothRemoteInitial()) {
    _loadCommands();
  }

  Future<void> _loadCommands() async {
    _prefs = await SharedPreferences.getInstance();
    _defaultCommands.forEach((command, defaultValue) {
      _commands[command] = _prefs.getString(command.toString()) ?? defaultValue;
    });
  }

  Future<void> connect({required BluetoothDevice device}) async {
    safeEmit(Connecting());
    try {
      _bluetoothConnection = await bluetooth.establishConnectionTo(device);
      safeEmit(Connected(message: "Connected to ${device.name ?? "Unknown"}!"));
    } catch (e) {
      safeEmit(ConnectionFailed(message: "${device.name} is not responding!"));
    }
  }

  Future<void> disconnect() async {
    await _bluetoothConnection!.finish();
    safeEmit(Disconnected(message: AppStrings.bluetoothDisconnected));
  }

  void _sendCommand(RobotCommand command) {
    log("Robot Command: ${_commands[command]}");
    _bluetoothConnection!.output
        .add(Uint8List.fromList(utf8.encode(_commands[command]!)));
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
