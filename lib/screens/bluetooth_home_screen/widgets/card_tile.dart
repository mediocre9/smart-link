import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class CardTile extends StatelessWidget {
  final BluetoothDevice device;
  final void Function() onPressed;

  const CardTile({
    Key? key,
    required this.device,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(device.name ?? "Unknown", style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Type: ${device.type.stringValue}', style: Theme.of(context).textTheme.labelMedium),
            Text('Bonded: ${device.isBonded ? "Yes" : "No"}', style: Theme.of(context).textTheme.labelMedium),
            Text('MAC: ${device.address}', style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}
