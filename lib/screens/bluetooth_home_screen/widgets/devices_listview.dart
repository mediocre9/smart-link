import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../cubit/bluetooth_home_cubit.dart';
import 'card_tile.dart';

class DevicesListView extends StatelessWidget {
  final List<BluetoothDevice> bluetoothDevices;
  final int totalDevices;
  final ThemeData theme;

  const DevicesListView({
    super.key,
    required this.theme,
    required this.bluetoothDevices,
    required this.totalDevices,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: bluetoothDevices.length,
        // separatorBuilder: (context, __) => const Divider(),
        itemBuilder: (context, i) {
          return CardTile(
            device: bluetoothDevices[i],
            theme: theme,
            onPressed: () {
              context
                  .read<BluetoothHomeCubit>()
                  .pairDevice(bluetoothDevices[i]);
            },
          );
        },
      ),
    );
  }
}
