import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue/flutter_blue.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FlutterBlue _blueTooth = FlutterBlue.instance;
  HomeCubit() : super(Initial());
  List<ScanResult> _devices = [];

  Future scanForDevices() async {
    if (await _blueTooth.isOn) {
      emit(Scanning());
      await _blueTooth.startScan(timeout: const Duration(seconds: 5));
      _blueTooth.scanResults.listen((devices) {
        _devices = devices;
      });
    }
    emit(Result(devices: _devices));
  }

  Future stopScanning() async {
    _blueTooth.stopScan();
  }
}
