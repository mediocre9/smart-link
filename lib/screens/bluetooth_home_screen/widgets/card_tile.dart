import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class CardTile extends StatelessWidget {
  final BluetoothDevice device;
  final void Function() onPressed;

  const CardTile({
    Key? key,
    required this.theme,
    required this.device,
    required this.onPressed,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(device.name!, style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Paired: ${device.isBonded ? "Yes" : "No"}',
                style: theme.textTheme.labelMedium),
            Text('Type: ${device.type.stringValue}',
                style: theme.textTheme.labelMedium),
            Text('MAC: ${device.address}', style: theme.textTheme.labelMedium),
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}
