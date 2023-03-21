import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remo_tooth/config/app_routes.dart';

import '../../config/app_strings.dart';
import '../../widgets/app_drawer.dart';
import 'cubit/wifi_home_cubit.dart';

class WifiHomeScreen extends StatelessWidget {
  static final TextEditingController _ip = TextEditingController();

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'IP',
                    helperText: "192.168.4.1",
                  ),
                  controller: _ip,
                ),
                SizedBox(height: mediaQuery.height / 40),
                BlocConsumer<WifiHomeCubit, WifiHomeState>(
                  builder: (context, state) {
                    if (state is Initial) {
                      return ElevatedButton(
                        child: const Text('Connect'),
                        onPressed: () => context
                            .read<WifiHomeCubit>()
                            .hasConnectionBeenEstablished(_ip.text),
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
