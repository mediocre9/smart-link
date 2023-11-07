import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/config/index.dart';
import '../../common/app_drawer.dart';
import '../../common/standard_app_widgets.dart';
import 'cubit/wifi_home_cubit.dart';

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
            IconButton(
              icon: const Icon(Icons.bug_report_rounded),
              onPressed: () => Navigator.pushNamed(context, Routes.feedback),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () => showAboutDialogWidget(context),
            ),
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
          Routes.wifiRemote,
          arguments: state.baseUrl,
        );
        break;

      case NotConnected():
        showSnackBarWidget(context, state.message);

      default:
    }
  }
}
