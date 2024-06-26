import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/common/common.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/screens/wifi_home_screen/cubit/wifi_home_cubit.dart';

class WifiHomeScreen extends StatelessWidget with StandardAppWidgets {
  const WifiHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Locker Home"),
          actions: [
            popupMenuButtonWidget(context),
          ],
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocConsumer<WifiHomeCubit, WifiHomeState>(
                  builder: _blocBuilders,
                  listener: _blocListeners,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 30),
                Text(
                  AppStrings.lockerHomeInfo,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.labelSmall!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _blocBuilders(BuildContext context, WifiHomeState state) {
    switch (state) {
      case Initial():
        return Center(
          child: ElevatedButton(
            child: const Text('Connect'),
            onPressed: () {
              context.read<WifiHomeCubit>().connectToESP8266();
            },
          ),
        );

      case Connecting():
        return const Center(child: CircularProgressIndicator());

      default:
        return Container();
    }
  }

  void _blocListeners(BuildContext context, WifiHomeState state) {
    switch (state) {
      case Connected():
        Navigator.pushNamed(
          context,
          AppRoutes.wifiRemote,
          arguments: state.baseUrl,
        );
        break;

      case NotConnected():
        showSnackBarWidget(context, state.message);

      default:
    }
  }
}
