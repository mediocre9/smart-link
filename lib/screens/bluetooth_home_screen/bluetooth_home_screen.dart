import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/common/common.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/config/router/routes.dart';
import 'package:smart_link/screens/bluetooth_home_screen/cubit/bluetooth_home_cubit.dart';
import 'package:smart_link/screens/bluetooth_home_screen/widgets/widgets.dart';

class BluetoothHomeScreen extends StatefulWidget {
  final IAuthenticationService authService;
  const BluetoothHomeScreen({super.key, required this.authService});

  @override
  State<BluetoothHomeScreen> createState() => _BluetoothHomeScreenState();
}

class _BluetoothHomeScreenState extends State<BluetoothHomeScreen>
    with StandardAppWidgets, SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    widget.authService.isRevoked().then((blocked) {
      if (blocked) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.auth,
          (context) => false,
        );
      } else {
        context.read<BluetoothHomeCubit>().init();
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: 1200.ms,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CURO 360 Robot"),
        actions: [
          BlocBuilder<BluetoothHomeCubit, BluetoothHomeState>(
            builder: (context, state) {
              log(state.runtimeType.toString());
              switch (state) {
                case Initial() || LoadedDevices():
                  return const StartScanButtonWidget();

                case LoadDevices():
                  return const StopScanButtonWidget();

                default:
                  return Container();
              }
            },
          ),
          popupMenuButtonWidget(context),
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(5),
        child: BlocConsumer<BluetoothHomeCubit, BluetoothHomeState>(
          listener: _blocListener,
          builder: _blocBuilder,
        ),
      ),
    );
  }

  Widget _blocBuilder(
    BuildContext context,
    BluetoothHomeState state,
  ) {
    switch (state) {
      case Initial():
        return const DescriptionWidget(
          text: AppStrings.bluetoothHomeDescription,
          icon: Icons.bluetooth_rounded,
        );

      case LoadDevices():
        return Column(
          children: [
            const LinearProgressIndicator(minHeight: 2),
            if (state.devices.isNotEmpty) ...[
              DevicesListWidget(devices: state.devices)
            ] else ...[
              const Expanded(
                child: DescriptionWidget(
                  text: AppStrings.bluetoothDiscoveryDescription,
                  icon: Icons.bluetooth_searching_rounded,
                ),
              ),
            ]
          ],
        );

      case LoadedDevices():
        return Column(
          children: [
            DevicesListWidget(devices: state.devices),
          ],
        );

      default:
        return Container();
    }
  }

  void _blocListener(BuildContext ctx, BluetoothHomeState state) {
    switch (state) {
      case AskForPermissions():
        showDialog(
          context: ctx,
          builder: (_) {
            return AlertDialog(
              title: const Text("Permission Access"),
              content: Text(state.message),
              actions: [
                TextButton(
                  child: const Text("Deny"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text("Allow"),
                  onPressed: () {
                    ctx.read<BluetoothHomeCubit>().openPermissionSettings();
                    Navigator.pop(ctx);
                  },
                ),
              ],
            );
          },
        );
        break;

      case DeviceConnection():
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.bluetoothRemote,
          arguments: state.device,
          (route) => false,
        );
        break;

      default:
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
