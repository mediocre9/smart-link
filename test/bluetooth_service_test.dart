import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_link/services/bluetooth_service.dart';

import 'bluetooth_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BluetoothService>()])
void main() {
  List<BluetoothDevice> dummyDevices = List.unmodifiable([
    const BluetoothDevice(
      name: "Device 1",
      address: "00-B0-D0-00-C2-26",
    ),
    const BluetoothDevice(
      name: "Device 2",
      address: "00-10-D0-02-C2-26",
    ),
  ]);

  group("BluetoothService Test", () {
    late IBluetoothService bluetoothService;

    setUp(() {
      bluetoothService = MockBluetoothService();
    });

    test("fetchPairedDevices should return list of paired devices", () async {
      when(bluetoothService.fetchPairedDevices()).thenAnswer((_) async => dummyDevices);

      final List<BluetoothDevice> result = await bluetoothService.fetchPairedDevices();

      verify(bluetoothService.fetchPairedDevices()).called(1);
      expect(result, dummyDevices);
    });

    test("enableBluetooth should return true if user-permission granted", () async {
      when(bluetoothService.enableBluetooth()).thenAnswer((_) async => true);

      final bool? result = await bluetoothService.enableBluetooth();

      verify(bluetoothService.enableBluetooth()).called(1);
      expect(result, true);
    });

    test("enableBluetooth should return false if user-permission not granted", () async {
      when(bluetoothService.enableBluetooth()).thenAnswer((_) async => false);

      final bool? result = await bluetoothService.enableBluetooth();

      verify(bluetoothService.enableBluetooth()).called(1);
      expect(result, false);
    });
  });
}
