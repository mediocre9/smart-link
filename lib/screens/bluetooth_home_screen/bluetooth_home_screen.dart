import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:lottie/lottie.dart';
import 'package:remo_tooth/config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_strings.dart';
import 'cubit/bluetooth_home_cubit.dart';

class BluetoothHomeScreen extends StatelessWidget {
  const BluetoothHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  AppString.APP_NAME,
                  style: theme.textTheme.displaySmall,
                ),
              ),
            ),
            ListTile(
              title: const Text("HC-06"),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, AppRoute.BLUETOOTH_REMOTE_HOME);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("Node MCU"),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, AppRoute.WIFI_REMOTE_HOME);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<BluetoothHomeCubit, BluetoothHomeState>(
        builder: (context, state) {
          if (state is Initial || state is FoundedBluetoothDevices) {
            return FloatingActionButton(
              child: const Icon(Icons.play_arrow_rounded),
              onPressed: () {
                context.read<BluetoothHomeCubit>().discoverDevices();
              },
            );
          } else if (state is DiscoveringDevices) {
            return FloatingActionButton(
              child: const Icon(Icons.stop_rounded),
              onPressed: () {
                context.read<BluetoothHomeCubit>().stopDiscovery();
              },
            );
          }
          return Container();
        },
      ),
      appBar: AppBar(
        title: const Text("Bluetooth Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _aboutDialogWidget(context, mediaQuery, theme),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocConsumer<BluetoothHomeCubit, BluetoothHomeState>(
              listener: (context, state) {
                if (state is BluetoothOnGoingResponse) {
                  _showSnackBar(state.message, context);
                } else if (state is DeviceHasbeenPaired) {
                  Navigator.pushReplacementNamed(
                      context, AppRoute.BLUETOOTH_REMOTE_CONTROLLER,
                      arguments: state.device);
                }
              },
              builder: (context, state) {
                if (state is Initial) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          state.icon,
                          size: mediaQuery.size.width / 5,
                          color: Colors.grey,
                        ),
                        Text(
                          state.message,
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  );
                } else if (state is FoundedBluetoothDevices) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: state.devices.length,
                      separatorBuilder: (context, __) => const Divider(),
                      itemBuilder: (context, i) {
                        return _CardTile(
                          device: state.devices[i],
                          theme: theme,
                          onPressed: () {
                            context
                                .read<BluetoothHomeCubit>()
                                .pairDevice(state.devices[i]);
                          },
                        );
                      },
                    ),
                  );
                } else if (state is DiscoveringDevices) {
                  return Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/animations/radar.json',
                          height: mediaQuery.size.height / 5,
                        ),
                        SizedBox(height: mediaQuery.size.height / 20),
                        Text(
                          AppString.DISCOVERING_MSG,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          "Founded device(s): ${context.watch<BluetoothHomeCubit>().foundedDevices}",
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  );
                } else if (state is DeviceIsPairing) {
                  return Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(height: mediaQuery.size.height / 20),
                        Text(
                          state.message,
                          style: theme.textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  void _aboutDialogWidget(
      BuildContext context, MediaQueryData mediaQuery, ThemeData theme) {
    return showAboutDialog(
      context: context,
      applicationName: AppString.APP_NAME,
      applicationVersion: AppString.APP_VERSION,
      applicationIcon: Image.asset(
        'assets/images/logo.png',
        width: mediaQuery.size.width / 5,
      ),
      children: [
        Text(
          AppString.COPYRIGHT,
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }

  void _showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _CardTile extends StatelessWidget {
  final BluetoothDevice device;
  final void Function() onPressed;

  const _CardTile({
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
        tileColor: device.isBonded
            ? const Color.fromARGB(255, 27, 26, 31)
            : theme.listTileTheme.tileColor,
        trailing: device.isBonded
            ? const Icon(
                Icons.bluetooth_connected_rounded,
                color: AppColors.PRIMARY_COLOR,
              )
            : const Icon(Icons.bluetooth_disabled_rounded),
        title: Text(device.name!, style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Type: ${device.type.stringValue}',
                style: theme.textTheme.labelMedium),
            Text('Paired: ${device.isBonded ? "Yes" : "No"}',
                style: theme.textTheme.labelMedium),
            Text('MAC: ${device.address}', style: theme.textTheme.labelMedium),
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}
