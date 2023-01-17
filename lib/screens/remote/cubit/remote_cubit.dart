import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'remote_state.dart';

class RemoteCubit extends Cubit<RemoteState> {
  RemoteCubit() : super(OffSignal());

  BluetoothDevice? device;

  Future<void> onMessage(BluetoothDevice device) async {
    emit(Loading());
    BluetoothConnection con =
        await BluetoothConnection.toAddress(device.address);
    con.output.add(Uint8List.fromList(utf8.encode('Hello')));
    con.dispose();
    listenResponse(device);
    emit(OnSignal());
  }

  Future<void> offMessage(BluetoothDevice device) async {
    emit(Loading());
    BluetoothConnection con =
        await BluetoothConnection.toAddress(device.address);
    con.output.add(Uint8List.fromList(utf8.encode('World')));
    con.dispose();
    emit(OffSignal());
  }

  Future listenResponse(BluetoothDevice device) async {
    emit(Loading());
    BluetoothConnection con =
        await BluetoothConnection.toAddress(device.address);
    con.input!.listen((event) {
      ascii.decode(event);
    }).onDone(() {
      con.dispose();
      emit(OffSignal());
    });
  }
}
