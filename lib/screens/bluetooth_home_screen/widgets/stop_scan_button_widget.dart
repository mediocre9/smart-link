import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/screens/bluetooth_home_screen/cubit/bluetooth_home_cubit.dart';

class StopScanButtonWidget extends StatelessWidget {
  const StopScanButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.pause),
      onPressed: () {
        context.read<BluetoothHomeCubit>().stopScan();
      },
    );
  }
}
