import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remo_tooth/config/router/app_routes.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/common.dart';
import 'cubit/wifi_home_cubit.dart';

class WifiHomeScreen extends StatelessWidget with StandardAppWidgets {
  const WifiHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Locker Home"),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () =>
                  showAboutDialogWidget(context, mediaQuery, Theme.of(context)),
            )
          ],
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: mediaQuery.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocConsumer<WifiHomeCubit, WifiHomeState>(
                  builder: (context, state) {
                    if (state is Initial) {
                      return Center(
                        child: ElevatedButton(
                          child: const Text('Connect'),
                          onPressed: () {
                            context.read<WifiHomeCubit>().establishConnection();
                          },
                        ),
                      );
                    } else if (state is Connecting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container();
                  },
                  listener: (context, state) {
                    if (state is NotConnected) {
                      showSnackBarWidget(context, state.message);
                    } else if (state is Connected) {
                      Navigator.pushNamed(
                        context,
                        Routes.kWifiRemote,
                        arguments: state.baseUrl,
                      );
                    }
                  },
                ),
                SizedBox(height: mediaQuery.size.height / 30),
                Text(
                  "Info: Connect to nodemcu ssid (It & Robotics - (Node-MCU)) through your system's wifi settings. After successful connection, simply press the connect button.",
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
}
