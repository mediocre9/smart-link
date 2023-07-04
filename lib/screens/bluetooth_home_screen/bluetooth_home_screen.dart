import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bluetooth_home_screen/widgets/index.dart';
import 'package:remo_tooth/widgets/app_drawer.dart';
import '../../config/router/app_routes.dart';
import '../../widgets/common.dart';
import 'cubit/bluetooth_home_cubit.dart';

class BluetoothHomeScreen extends StatelessWidget with StandardAppWidgets {
  const BluetoothHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => showAboutDialogWidget(context, mediaQuery, theme),
          )
        ],
      ),
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
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocConsumer<BluetoothHomeCubit, BluetoothHomeState>(
              listener: (context, state) {
                if (state is BluetoothDisabled) {
                  showSnackBarWidget(context, state.message);
                } else if (state is PairSuccessful) {
                  showSnackBarWidget(
                    context,
                    state.message,
                    color: state.snackbarColor,
                  );
                } else if (state is PairUnsuccessful) {
                  showSnackBarWidget(
                    context,
                    state.message,
                    color: state.snackbarColor,
                  );
                } else if (state is HasNotFoundNewDevices) {
                  showSnackBarWidget(
                    context,
                    state.message,
                  );
                } else if (state is ConnectToRemoteDevice) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.kBluetoothRemote,
                    arguments: state.device,
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                if (state is Initial) {
                  return InitialHomeScreen(
                    text: state.text,
                    icon: state.icon,
                    mediaQuery: mediaQuery,
                    theme: theme,
                  );
                } else if (state is ShowPairedDevices) {
                  return DevicesListView(
                    theme: theme,
                    bluetoothDevices: state.pairedDevices,
                    totalDevices: state.totalPairedDevices,
                  );
                } else if (state is ShowDiscoveredDevices) {
                  return DevicesListView(
                    theme: theme,
                    bluetoothDevices: state.discoveredDevices,
                    totalDevices: state.totalDiscoveredDevices,
                  );
                } else if (state is DiscoverNewDevices) {
                  return RadarAnimation(
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
}
