import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remo_tooth/config/app_routes.dart';

import '../../config/app_strings.dart';
import '../../widgets/app_drawer.dart';
import 'cubit/wifi_home_cubit.dart';

class WifiHomeScreen extends StatelessWidget {
  const WifiHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: AppString.APP_NAME,
                  applicationVersion: AppString.APP_VERSION,
                  applicationIcon: Image.asset(
                    'assets/images/logo.png',
                    width: mediaQuery.width / 5,
                  ),
                  children: [
                    Text(
                      AppString.COPYRIGHT,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                );
              },
              icon: const Icon(Icons.info_outline_rounded),
            )
          ],
          title: const Text("Locker Home"),
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: mediaQuery.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocConsumer<WifiHomeCubit, WifiHomeState>(
                  builder: (context, state) {
                    if (state is Initial) {
                      return Center(
                        child: ElevatedButton(
                          child: const Text('Connect'),
                          onPressed: () => context
                              .read<WifiHomeCubit>()
                              .establishConnection(),
                        ),
                      );
                    } else if (state is Connecting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container();
                  },
                  listener: (context, state) {
                    if (state is NotConnected) {
                      _showSnackBar(state.message, context);
                    } else if (state is Connected) {
                      Navigator.pushNamed(
                        context,
                        AppRoute.WIFI_REMOTE_CONTROLLER,
                        arguments: state.baseUrl,
                      );
                    }
                  },
                ),
                SizedBox(height: mediaQuery.height / 30),
                Text(
                  "Help: Connect to nodemcu ssid (It & Robotics - (Node-MCU)) through your system's wifi settings. After successful connection, simply press the connect button.",
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

  void _showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
