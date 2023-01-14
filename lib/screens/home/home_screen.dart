import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remo_tooth/config/app_strings.dart';

import '../../config/app_routes.dart';
import '../sign_in/cubit/sign_in_cubit.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  final User userCredential;
  const HomeScreen({super.key, required this.userCredential});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.play_arrow_sharp),
        onPressed: () => BlocProvider.of<HomeCubit>(context).scanForDevices(),
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
                  children: [
                    const Text(
                      "Developed by ${AppString.DEVELOPER}",
                    )
                  ],
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
            BlocConsumer<HomeCubit, HomeState>(
              listener: (_, state) {
                if (state is DevicesNotFound) {
                  ScaffoldMessenger.of(_).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is DevicesFound) {
                  ScaffoldMessenger.of(_).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${state.totalFoundDevices} device(s) found!',
                      ),
                    ),
                  );
                } else if (state is BluetoothNotEnabled) {
                  ScaffoldMessenger.of(_).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (_, state) {
                if (state is DevicesFound) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: state.devices.length,
                      separatorBuilder: (_, index) => const Divider(),
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text(state.devices[index].name!),
                          subtitle: Text(state.devices[index].address),
                          trailing: const Icon(Icons.tap_and_play_rounded),
                          dense: true,
                          onTap: () {},
                        );
                      },
                    ),
                  );
                } else if (state is Scanning) {
                  return Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                        const Text(
                          AppString.ON_SCAN_MSG,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
