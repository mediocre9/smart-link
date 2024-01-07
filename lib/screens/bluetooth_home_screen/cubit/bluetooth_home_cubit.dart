import 'package:bloc/bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/services/services.dart';

part 'bluetooth_home_state.dart';

class BluetoothHomeCubit extends Cubit<BluetoothHomeState> {
  final IBluetoothService bluetooth;
  final IPermissionService permission;
  final Set<BluetoothDevice> _discovered = {};

  BluetoothHomeCubit({
    required this.bluetooth,
    required this.permission,
  }) : super(Initial()) {
    _init();
  }

  Future _init() async {
    if (await _handlePermissions()) {
      await _startBluetoothAdapterListener();
      await _getPairedDevices();
    }
  }

  Future<bool> _handlePermissions() async {
    bool hasPermissions = await permission.requestPermissions();

    if (!hasPermissions) {
      emit(AskForPermissions(message: AppStrings.permissionInfo));
      emit(Initial());
    }

    return hasPermissions;
  }

  Future<void> _startBluetoothAdapterListener() async {
    await for (final state in bluetooth.onAdapterStateChanges()) {
      if (state == BluetoothState.STATE_OFF) {
        emit(Initial());
      } else if (state == BluetoothState.STATE_ON) {
        if (await _handlePermissions()) {
          await _bluetoothStateOn();
        }
      }
    }
  }

  Future<void> _bluetoothStateOn() async {
    await _getPairedDevices();
    await startScan();
  }

  Future<void> _getPairedDevices() async {
    final pairedDevices = await bluetooth.getPairedDevices();
    _discovered
      ..clear()
      ..addAll(pairedDevices);

    final state = _discovered.isNotEmpty
        ? LoadedDevices(devices: _discovered.toList())
        : Initial();

    emit(state);
  }

  Future<void> startScan() async {
    // Before proceeding to use the bluetooth features,
    // permissions must have to be ensured and allowed
    // to avoid the potential crashes.
    bool hasPermissions = await _handlePermissions();
    if (!hasPermissions) return;

    bool? isAdapterEnabled = await bluetooth.enableBluetoothAdapter();

    if (!(isAdapterEnabled)!) {
      emit(Initial());
      return;
    }

    await _getPairedDevices();
    emit(LoadDevices(devices: _discovered.toList()));

    await for (final results in bluetooth.startDiscovery()) {
      _discovered
        ..removeWhere((e) => e.address == results.device.address)
        ..add(results.device);

      emit(LoadDevices(devices: _discovered.toList()));
    }

    if (_discovered.isNotEmpty) {
      emit(LoadedDevices(devices: _discovered.toList()));
    } else {
      _getPairedDevices();
    }
  }

  Future<void> stopScan() async {
    await bluetooth.cancelDiscovery();
  }

  Future<void> openPermissionSettings() async {
    await permission.openPermissionSettings();
  }

  Future<void> bondDevice(BluetoothDevice device) async {
    await stopScan();

    if (device.isBonded) {
      emit(DeviceConnection(device: device));
      return;
    }

    await _showLoading(device.name);
    bool? isBonded = await bluetooth.bondDevice(device);
    await _dismissLoading();

    final state = isBonded!
        ? DeviceConnection(device: device)
        : LoadedDevices(devices: _discovered.toList());

    emit(state);
  }

  Future<void> _showLoading(String? name) async {
    String message = 'Pairing with ${name ?? "Unknown Device"} . . .';
    await EasyLoading.show(
      status: message,
      maskType: EasyLoadingMaskType.black,
    );
  }

  Future<void> _dismissLoading() async {
    await EasyLoading.dismiss();
  }
}
