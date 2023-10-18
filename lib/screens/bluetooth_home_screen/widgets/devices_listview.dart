import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../cubit/bluetooth_home_cubit.dart';
import 'card_tile.dart';

class DevicesListView extends StatelessWidget {
  final List<BluetoothDevice> devices;

  const DevicesListView({
    super.key,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, i) {
          return CardTile(
            device: devices[i],
            onPressed: () {
              context.read<BluetoothHomeCubit>().pairDevice(devices[i]);
            },
          );
        },
      ),
    );
  }
}
