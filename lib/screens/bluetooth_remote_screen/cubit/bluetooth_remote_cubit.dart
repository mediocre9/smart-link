import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_link/config/strings/strings.dart';

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
  BluetoothRemoteCubit() : super(ConnectedToBluetoothDevice());

  final Map<RobotCommand, String> _commands = {
    RobotCommand.forward: "F",
    RobotCommand.backward: "B",
    RobotCommand.left: "L",
    RobotCommand.right: "R",
    RobotCommand.stop: "X",
    RobotCommand.cameraUp: "W",
    RobotCommand.cameraDown: "S",
    RobotCommand.cameraLeft: "A",
    RobotCommand.cameraRight: "D",
    RobotCommand.cameraStop: "0"
  };

  BluetoothDevice? device;
  BluetoothConnection? _connection;

  Future<void> connect(BluetoothDevice device) async {
    emit(EstablishingBluetoothConnection());

    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      emit(ConnectionStatus(message: Strings.bluetoothConnected));
      emit(ConnectedToBluetoothDevice());
    } catch (e) {
      emit(ConnectionStatus(message: Strings.endDeviceNotResponding));
    }
  }

  Future<void> disconnect() async {
    await _connection!.finish();
    emit(ConnectionStatus(message: Strings.bluetoothDisconnected));
  }

  void _sendCommand(RobotCommand command) {
    _connection!.output.add(Uint8List.fromList(utf8.encode(_commands[command] ?? "")));
  }

  void reset() => _sendCommand(RobotCommand.stop);

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
