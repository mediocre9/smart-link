import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_link/config/colors/app_colors.dart';

import '../cubit/bluetooth_home_cubit.dart';

class DevicesListWidget extends StatelessWidget {
  final Color? color;
  final List<BluetoothDevice> devices;

  const DevicesListWidget({
    super.key,
    this.color,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, i) {
          return _CardTileWidget(
            color: color,
            device: devices[i],
            onPressed: () {
              context.read<BluetoothHomeCubit>().bondDevice(devices[i]);
            },
          );
        },
      ),
    );
  }
}

class _CardTileWidget extends StatelessWidget {
  final BluetoothDevice device;
  final Color? color;
  final void Function() onPressed;

  const _CardTileWidget({
    this.color,
    required this.device,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
            child: ListTile(
                tileColor: device.isBonded
                    ? AppColors.pairedCard
                    : AppColors.discoveredCard,
                enableFeedback: true,
                title: Text(device.name!,
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Type: ${device.type.stringValue}',
                        style: Theme.of(context).textTheme.labelMedium),
                    Text('Bonded: ${device.isBonded ? "Yes" : "No"}',
                        style: Theme.of(context).textTheme.labelMedium),
                    Text('MAC: ${device.address}',
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                onTap: onPressed))
        .animate()
        .fadeIn(duration: 600.ms)
        .slide(curve: Curves.easeInOut, begin: const Offset(-1, 0));
  }
}
