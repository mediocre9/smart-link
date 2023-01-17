import 'package:bloc/bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/config/app_strings.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  final List<BluetoothDevice> _foundedDevices = List.empty(growable: true);

  HomeCubit() : super(Initial(message: 'Scan for beacon devices')) {
    _getPairedDevices();
  }

  Future<bool?> get isBluetoothEnabled async => _bluetooth.isEnabled;

  /// retrieves all paired devices.
  Future<void> _getPairedDevices() async {
    _foundedDevices.clear();
    if ((await isBluetoothEnabled)!) {
      emit(Discovering(message: 'Getting paired devices . . .'));
      await _bluetooth
          .getBondedDevices()
          .then((paired) => _foundedDevices.addAll(paired))
          .whenComplete(() {
        if (_foundedDevices.isNotEmpty) {
          emit(ShowDevices(
            totalDevices: _foundedDevices.length,
            devices: _foundedDevices,
          ));
        } else {
          discoverDevices();
        }
      });
    } else {
      await _bluetooth.requestEnable().then((isBluetoothTurnedOn) {
        if (isBluetoothTurnedOn!) {
          _getPairedDevices();
        } else {
          // emit(BluetoothResponse(message: AppString.DISABLED_BLUETOOTH_MSG));
          emit(Initial(message: 'Scan for beacon devices'));
        }
      });
    }
  }

  /// finds nearby beacon bluetooth devices for pairing.
  Future<void> discoverDevices() async {
    _foundedDevices.clear();
    if ((await isBluetoothEnabled)!) {
      emit(Discovering(message: AppString.DISCOVERING_MSG));
      _bluetooth.startDiscovery().listen((e) {
        _foundedDevices.add(e.device);
      }).onDone(() {
        if (_foundedDevices.isNotEmpty) {
          emit(ShowDevices(
            totalDevices: _foundedDevices.length,
            devices: _foundedDevices,
          ));
        } else {
          emit(BluetoothResponse(message: AppString.UNDISCOVERED_DEVICES_MSG));
          emit(Initial(message: 'Scan for beacon devices'));
        }
      });
    } else {
      await _bluetooth.requestEnable().then((isBluetoothTurnedOn) {
        if (isBluetoothTurnedOn!) {
          _getPairedDevices();
        } else {
          emit(BluetoothResponse(message: AppString.DISABLED_BLUETOOTH_MSG));
          emit(Initial(message: 'Scan for beacon devices'));
        }
      });
    }
  }

  /// Tries to pair with discovered unpaired device.
  Future<void> pairDevice(BluetoothDevice device) async {
    if (!device.isBonded) {
      emit(Pairing(
          message: 'Trying to pair with ${device.name}. Please be patient!'));
      await _bluetooth.bondDeviceAtAddress(device.address).then((connState) {
        if (connState!) {
          device;
          emit(BluetoothResponse(message: 'Paired to ${device.name}!'));
          emit(Paired(device: device));
        } else {
          emit(
              BluetoothResponse(message: 'Couldn`t pair with ${device.name}!'));
          emit(ShowDevices(
            totalDevices: _foundedDevices.length,
            devices: _foundedDevices,
          ));
        }
      });
    } else if (device.isBonded) {
      emit(Paired(device: device));
    }
  }

  /// Unpairs a bonded/paired device.
  Future<void> unPairDevice(BluetoothDevice device) async {
    _foundedDevices.removeWhere((element) => element.address == device.address);
    if (device.isBonded) {
      await _bluetooth
          .removeDeviceBondWithAddress(device.address)
          .then((isUnPairSucessful) {
        if (isUnPairSucessful!) {
          emit(BluetoothResponse(
              message: 'Device ${device.name} has been unpaired!'));
        }
      });
    }
  }
}
