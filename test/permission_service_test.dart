import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_link/services/permission_service.dart';
import 'permission_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BluetoothPermissionService>()])
void main() {
  group('BluetoothPermissionService tests', () {
    late IPermissionService permissionService;

    setUp(() {
      permissionService = MockBluetoothPermissionService();
    });

    test('requestPermissions should return true if all permissions are granted', () async {
      when(permissionService.requestPermissions()).thenAnswer((_) async => true);

      final bool result = await permissionService.requestPermissions();

      verify(permissionService.requestPermissions()).called(1);

      expect(result, true);
    });

    test('requestPermissions should return false if any permission is not granted', () async {
      when(permissionService.requestPermissions()).thenAnswer((_) async => false);

      final bool result = await permissionService.requestPermissions();

      verify(permissionService.requestPermissions()).called(1);

      expect(result, false);
    });
  });
}
