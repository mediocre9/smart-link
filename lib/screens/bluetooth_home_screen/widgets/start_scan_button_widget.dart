import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/screens/bluetooth_home_screen/cubit/bluetooth_home_cubit.dart';

class StartScanButtonWidget extends StatelessWidget {
  const StartScanButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.play_arrow_rounded),
      onPressed: () {
        context.read<BluetoothHomeCubit>().startScan();
      },
    );
  }
}
