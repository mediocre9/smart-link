import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, ReadContext;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    show BluetoothDevice;
import 'package:remo_tooth/config/app_strings.dart';
import 'package:remo_tooth/screens/home/cubit/home_cubit.dart';
import 'package:lottie/lottie.dart';
import '../../config/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: theme.elevatedButtonTheme.style!.copyWith(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 40),
          ),
        ),
        child: const Text('Scan'),
        onPressed: () => context.read<HomeCubit>().discoverDevices(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text(AppString.APP_NAME),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is BluetoothResponse) {
                  _showSnackBar(state.message, context);
                } else if (state is Paired) {
                  Navigator.pushReplacementNamed(context, AppRoute.REMOTE,
                      arguments: state.device);
                }
              },
              builder: (context, state) {
                if (state is Initial) {
                  return Center(
                    child: Text(
                      state.message,
                      style: theme.textTheme.titleSmall,
                    ),
                  );
                } else if (state is ShowDevices) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: state.devices.length,
                      separatorBuilder: (context, __) => const Divider(),
                      itemBuilder: (context, i) {
                        return _CardTile(
                          device: state.devices[i],
                          theme: theme,
                          onPressed: () => context
                              .read<HomeCubit>()
                              .pairDevice(state.devices[i]),
                        );
                      },
                    ),
                  );
                } else if (state is Discovering) {
                  return Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/animations/radar.json',
                          height: mediaQuery.size.height / 5,
                        ),
                        SizedBox(height: mediaQuery.size.height / 20),
                        Text(state.message, style: theme.textTheme.titleSmall),
                      ],
                    ),
                  );
                } else if (state is Pairing) {
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
        trailing: device.isBonded
            ? const Icon(Icons.bluetooth_connected_rounded)
            : const Icon(Icons.bluetooth_disabled_rounded),
        title: Text(device.name!, style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Type: ${device.type.stringValue}',
                style: theme.textTheme.labelMedium),
            Text('Paired: ${device.isBonded}',
                style: theme.textTheme.labelMedium),
            Text('MAC: ${device.address}', style: theme.textTheme.labelMedium),
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}
