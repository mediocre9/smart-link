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


    /**
     * Wrote test cases, have tested
     * on real devices. Wrote an external server script to
     * this library and even did some changes to library's
     * java source code for testing purpose. Still no luck... :(
     * 
     * Culprit code is below that establishes connection 
     * between devices...
     */
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
