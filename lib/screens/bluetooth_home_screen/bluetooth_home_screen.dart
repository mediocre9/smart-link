import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:lottie/lottie.dart';
import 'package:remo_tooth/widgets/app_drawer.dart';
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
      drawer: const AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<BluetoothHomeCubit, BluetoothHomeState>(
        builder: (context, state) {
          if (state is Initial ||
              state is ShowPairedDevices ||
              state is ShowDiscoveredDevices) {
            return FloatingActionButton(
              child: const Icon(Icons.play_arrow_rounded),
              onPressed: () {
                context.read<BluetoothHomeCubit>().discoverDevices();
              },
            );
          } else if (state is DiscoverNewDevices) {
            return FloatingActionButton(
              child: const Icon(Icons.pause),
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
            onPressed: () => _showAboutDialog(context, mediaQuery, theme),
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
                if (state is BluetoothDisabled) {
                  _showSnackBar(context, state.message);
                } else if (state is PairSuccessful) {
                  _showSnackBar(
                    context,
                    state.message,
                    color: state.snackbarColor,
                  );
                } else if (state is PairUnsuccessful) {
                  _showSnackBar(
                    context,
                    state.message,
                    color: state.snackbarColor,
                  );
                } else if (state is HasNotFoundNewDevices) {
                  _showSnackBar(
                    context,
                    state.message,
                  );
                } else if (state is ConnectToRemoteDevice) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoute.BLUETOOTH_REMOTE_CONTROLLER,
                    arguments: state.device,
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                if (state is Initial) {
                  return _InitialHomeScreen(
                    text: state.text,
                    icon: state.icon,
                    mediaQuery: mediaQuery,
                    theme: theme,
                  );
                } else if (state is ShowPairedDevices) {
                  return _ListBluetoothDevices(
                    theme: theme,
                    bluetoothDevices: state.pairedDevices,
                    totalDevices: state.totalPairedDevices,
                  );
                } else if (state is ShowDiscoveredDevices) {
                  return _ListBluetoothDevices(
                    theme: theme,
                    bluetoothDevices: state.discoveredDevices,
                    totalDevices: state.totalDiscoveredDevices,
                  );
                } else if (state is DiscoverNewDevices) {
                  return _DiscoveryAnimation(
                    text: state.text,
                    mediaQuery: mediaQuery,
                    theme: theme,
                  );
                } else if (state is PairDevice) {
                  return Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(height: mediaQuery.size.height / 20),
                        Text(
                          state.text,
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

  void _showAboutDialog(
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

  void _showSnackBar(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}

class _DiscoveryAnimation extends StatelessWidget {
  final String text;
  final MediaQueryData mediaQuery;
  final ThemeData theme;

  const _DiscoveryAnimation({
    required this.mediaQuery,
    required this.theme,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            'assets/animations/radar.json',
            height: mediaQuery.size.height / 5,
          ),
          SizedBox(height: mediaQuery.size.height / 20),
          Text(
            text,
            style: theme.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InitialHomeScreen extends StatelessWidget {
  final String text;
  final IconData icon;

  const _InitialHomeScreen({
    required this.mediaQuery,
    required this.theme,
    required this.text,
    required this.icon,
  });

  final MediaQueryData mediaQuery;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            icon,
            size: mediaQuery.size.width / 5,
            color: Colors.grey,
          ),
          Text(
            text,
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class _ListBluetoothDevices extends StatelessWidget {
  final List<BluetoothDevice> bluetoothDevices;
  final int totalDevices;
  final ThemeData theme;

  const _ListBluetoothDevices({
    required this.theme,
    required this.bluetoothDevices,
    required this.totalDevices,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: bluetoothDevices.length,
        separatorBuilder: (context, __) => const Divider(),
        itemBuilder: (context, i) {
          return _CardTile(
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
