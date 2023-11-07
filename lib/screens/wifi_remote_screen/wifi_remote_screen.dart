import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/common/app_drawer.dart';
import 'cubit/wifi_remote_cubit.dart';

class WifiRemoteScreen extends StatelessWidget {
  // dependent on wifi home cubit (route_args) . . .
  final String baseUrl;
  const WifiRemoteScreen({super.key, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Locker")),
      drawer: AppDrawer(),
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
                  BlocBuilder<WifiRemoteCubit, WifiRemoteState>(
                    builder: _blocBuilders,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blocBuilders(BuildContext context, WifiRemoteState state) {
    switch (state) {
      case Loading():
        return FloatingActionButton.large(
          child: const CircularProgressIndicator(),
          onPressed: () => context.read<WifiRemoteCubit>().sendOnMessage(baseUrl),
        );
      case OnSignal():
        return FloatingActionButton.large(
          foregroundColor: const Color.fromARGB(255, 147, 240, 170),
          child: const Icon(Icons.power_settings_new_rounded),
          onPressed: () => context.read<WifiRemoteCubit>().sendOffMessage(baseUrl),
        );
      case OffSignal():
        return FloatingActionButton.large(
          child: const Icon(Icons.power_settings_new_rounded),
          onPressed: () => context.read<WifiRemoteCubit>().sendOnMessage(baseUrl),
        );
      default:
        return Container();
    }
  }
}
