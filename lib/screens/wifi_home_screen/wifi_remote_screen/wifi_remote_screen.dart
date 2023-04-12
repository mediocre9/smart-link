import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/wifi_remote_cubit.dart';

class WifiRemoteScreen extends StatelessWidget {
  final String baseUrl;
  const WifiRemoteScreen({super.key, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Locker Controller")),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocConsumer<WifiRemoteCubit, WifiRemoteState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is Loading) {
                        return FloatingActionButton.large(
                          child: const CircularProgressIndicator(),
                          onPressed: () =>
                              context.read<WifiRemoteCubit>().on(baseUrl),
                        );
                      } else if (state is OnSignal) {
                        return FloatingActionButton.large(
                          foregroundColor:
                              const Color.fromARGB(255, 147, 240, 170),
                          child: const Icon(Icons.power_settings_new_rounded),
                          onPressed: () =>
                              context.read<WifiRemoteCubit>().off(baseUrl),
                        );
                      } else if (state is OffSignal) {
                        return FloatingActionButton.large(
                          child: const Icon(Icons.power_settings_new_rounded),
                          onPressed: () =>
                              context.read<WifiRemoteCubit>().on(baseUrl),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
