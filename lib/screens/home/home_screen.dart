import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remo_tooth/config/app_strings.dart';

import '../../config/app_routes.dart';
import '../sign_in/cubit/sign_in_cubit.dart' hide Initial, Loading;
import 'cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  final User userCredential;
  const HomeScreen({super.key, required this.userCredential});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.play_arrow_sharp),
        onPressed: () => BlocProvider.of<HomeCubit>(context).discoverDevices(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text(AppString.APP_NAME),
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                BlocProvider.of<SignInCubit>(context).signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.SIGN_UP,
                  (route) => false,
                );
              } else {
                showAboutDialog(
                  context: context,
                  applicationName: AppString.APP_NAME,
                  applicationVersion: AppString.APP_VERSION,
                  children: [const Text(AppString.DEVELOPER)],
                );
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Logout'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('About'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /**
             * Handling UI states here . . . 
             */

            BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is BluetoothResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is ShowDevices) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: state.devices.length,
                      separatorBuilder: (_, index) => const Divider(),
                      itemBuilder: (_, index) {
                        return Card(
                          color: Colors.blue[50],
                          child: ListTile(
                            title: Text(state.devices[index].name!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Type: ${state.devices[index].type.stringValue}'),
                                Text('MAC: ${state.devices[index].address}'),
                              ],
                            ),
                            trailing: const Icon(Icons.tap_and_play_rounded),
                            dense: true,
                            onLongPress: () {
                              BlocProvider.of<HomeCubit>(context)
                                  .unPairDevice(state.devices[index]);
                            },
                            onTap: () {
                              BlocProvider.of<HomeCubit>(context)
                                  .establishConnectionToDevice(
                                      state.devices[index]);
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is Connected) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: () =>
                              BlocProvider.of<HomeCubit>(context).onMessage(),
                          backgroundColor: Colors.orange,
                          child: const Text('1'),
                        ),
                        const SizedBox(height: 20),
                        FloatingActionButton(
                          onPressed: () =>
                              BlocProvider.of<HomeCubit>(context).offMessage(),
                          backgroundColor: Colors.orange,
                          child: const Text('0'),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'CAUTION: Unstable code here! The application may crash here...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                } else if (state is Loading) {
                  return Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                        Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        )
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
