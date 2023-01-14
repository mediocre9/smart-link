import 'package:bloc/bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/config/app_strings.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(Initial());
  final List<BluetoothDevice> _devices = [];

  scanForDevices() async {
    _devices.clear();
    bool? isBluetoothEnabled = await FlutterBluetoothSerial.instance.isEnabled;

    if (isBluetoothEnabled!) {
      emit(Scanning());
      FlutterBluetoothSerial.instance.startDiscovery().listen((event) {
        _devices.add(event.device);
      }).onDone(() {
        if (_devices.isNotEmpty) {
          emit(DevicesFound(
            devices: _devices,
            totalFoundDevices: _devices.length,
          ));
          return;
        } else {
          emit(DevicesNotFound(
            message: AppString.DEVICES_NOT_FOUND,
          ));
          return;
        }
      });
    } else {
      emit(BluetoothNotEnabled(message: AppString.BLUE_TOOTH_SERVICE_MSG));
    }
  }
}
