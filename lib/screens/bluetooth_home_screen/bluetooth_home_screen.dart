import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/screens/bluetooth_home_screen/widgets/devices_listview.dart';
import 'package:smart_link/screens/bluetooth_home_screen/widgets/initial_widget.dart';
import 'package:smart_link/screens/bluetooth_home_screen/widgets/radar_animation.dart';
import 'package:smart_link/widgets/app_drawer.dart';
import '../../config/router/routes.dart';
import '../../widgets/common.dart';
import 'cubit/bluetooth_home_cubit.dart';

class BluetoothHomeScreen extends StatelessWidget with StandardAppWidgets {
  const BluetoothHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => showAboutDialogWidget(context),
          )
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<BluetoothHomeCubit, BluetoothHomeState>(
        builder: _floatingButtonBlocBuilder,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocConsumer<BluetoothHomeCubit, BluetoothHomeState>(
              listener: _blocListeners,
              builder: _blocBuilders,
            )
          ],
        ),
      ),
    );
  }

  Widget _floatingButtonBlocBuilder(
    BuildContext context,
    BluetoothHomeState state,
  ) {
    switch (state) {
      case Initial() || ShowPairedDevices() || ShowDiscoveredDevices():
        return FloatingActionButton(
          child: const Icon(Icons.play_arrow_rounded),
          onPressed: () {
            context.read<BluetoothHomeCubit>().startScan();
          },
        );

      case DiscoverDevices():
        return FloatingActionButton(
          child: const Icon(Icons.pause),
          onPressed: () {
            context.read<BluetoothHomeCubit>().stopScan();
          },
        );

      default:
        return Container();
    }
  }

  void _blocListeners(BuildContext context, BluetoothHomeState state) {
    switch (state) {
      case BluetoothDisabled():
        showSnackBarWidget(context, state.message);
        break;

      case PairSuccessful():
        showSnackBarWidget(
          context,
          state.message,
          color: state.snackbarColor,
        );
        break;

      case PairUnsuccessful():
        showSnackBarWidget(
          context,
          state.message,
          color: state.snackbarColor,
        );
        break;

      case HasNotFoundNewDevices():
        showSnackBarWidget(context, state.message);
        break;

      case ConnectToRemoteDevice():
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.bluetoothRemote,
          arguments: state.device,
          (route) => false,
        );
        break;
      default:
    }
  }

  Widget _blocBuilders(BuildContext context, BluetoothHomeState state) {
    switch (state) {
      case Initial():
        return InitialHomeScreen(
          text: state.text,
          icon: state.icon,
        );

      case ShowPairedDevices():
        return DevicesListView(devices: state.devices);
      case ShowDiscoveredDevices():
        return DevicesListView(devices: state.devices);
      case DiscoverDevices():
        return RadarAnimation(text: state.text);

      case PairDevice():
        return Center(
          child: Column(
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              Text(
                state.text,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }
}
