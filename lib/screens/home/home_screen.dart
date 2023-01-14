import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remo_tooth/config/app_routes.dart';

import '../sign_in/cubit/sign_in_cubit.dart' hide Initial;
import 'cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  final User userCredential;
  const HomeScreen({super.key, required this.userCredential});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(userCredential.photoURL!),
          ),
          TextButton.icon(
            label: const Text("Log Out"),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white)),
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              BlocProvider.of<SignInCubit>(context).signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoute.SIGN_UP, (route) => false);
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
            // BlocConsumer<HomeCubit, HomeState>(
            //   listener: (context, state) {
            //     if (state is Result) {
            //       ListView.builder(
            //         itemCount: state.devices.length,
            //         itemBuilder: (context, index) {
            //           return ListTile(
            //               title: Text(state.devices[index].device.name));
            //         },
            //       );
            //     }
            //   },
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is Initial) {
                  return ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<HomeCubit>(context).scanForDevices();
                      },
                      child: const Text("Scan"));
                }
                if (state is Scanning) {
                  return const Center(child: CircularProgressIndicator());
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
