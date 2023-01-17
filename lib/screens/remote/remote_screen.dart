import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/screens/remote/cubit/remote_cubit.dart';

class RemoteScreen extends StatelessWidget {
  final BluetoothDevice device;
  const RemoteScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    var event = BlocProvider.of<RemoteCubit>(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    var message = '0';

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name!),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [];
            },
          ),
        ],
      ),
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
                  BlocConsumer<RemoteCubit, RemoteState>(
                    listener: (context, state) {
                      if (state is ListenResponse) {
                        message = state.message;
                      }
                    },
                    builder: (context, state) {
                      if (state is Loading) {
                        return FloatingActionButton.large(
                          child: const CircularProgressIndicator(),
                          onPressed: () => event.onMessage(device),
                        );
                      } else if (state is OnSignal) {
                        return FloatingActionButton.large(
                          foregroundColor:
                              const Color.fromARGB(255, 131, 78, 255),
                          child: const Icon(Icons.power_settings_new_rounded),
                          onPressed: () => event.offMessage(device),
                        );
                      } else if (state is OffSignal) {
                        return FloatingActionButton.large(
                          child: const Icon(Icons.power_settings_new_rounded),
                          onPressed: () => event.onMessage(device),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 6,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Console Log:', style: theme.textTheme.labelLarge),
                    SizedBox(height: mediaQuery.size.height / 150),
                    Text('Device: ${device.name}',
                        style: theme.textTheme.labelMedium),
                    Text('Connected: ${device.isConnected}',
                        style: theme.textTheme.labelMedium),
                    Text('MAC: ${device.address}',
                        style: theme.textTheme.labelMedium),
                    Text('Signal Status: $message',
                        style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
