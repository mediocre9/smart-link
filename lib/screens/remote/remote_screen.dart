import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remo_tooth/screens/remote/cubit/remote_cubit.dart';

class RemoteScreen extends StatefulWidget {
  final BluetoothDevice device;
  const RemoteScreen({super.key, required this.device});

  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
  @override
  void initState() {
    () async {
      await BlocProvider.of<RemoteCubit>(context).connect(widget.device);
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var event = BlocProvider.of<RemoteCubit>(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name!),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.blue),
                        ),
                        child: const Icon(Icons.arrow_circle_up_rounded),
                        onPressed: () async {
                          event.moveForward();
                          await HapticFeedback.heavyImpact();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.blue),
                            ),
                            child: const Icon(Icons.arrow_circle_left_outlined),
                            onPressed: () => event.moveLeft(),
                          ),
                          OutlinedButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.blue),
                            ),
                            child:
                                const Icon(Icons.arrow_circle_right_outlined),
                            onPressed: () => event.moveRight(),
                          ),
                        ],
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.blue),
                        ),
                        child: const Icon(Icons.arrow_circle_down_rounded),
                        onPressed: () => event.moveBackward(),
                      ),
                    ],
                  ),
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
                child: BlocBuilder<RemoteCubit, RemoteState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          LinearProgressIndicator(),
                        ],
                      );
                    } else if (state is Initial) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Console Log:',
                              style: theme.textTheme.labelLarge),
                          SizedBox(height: mediaQuery.size.height / 150),
                          Text('Device: ${widget.device.name}',
                              style: theme.textTheme.labelMedium),
                          Text('Connected: ${state.status}',
                              style: theme.textTheme.labelMedium),
                          Text('MAC: ${widget.device.address}',
                              style: theme.textTheme.labelMedium),
                          Text('Operation Status: ${state.message}',
                              style: theme.textTheme.labelSmall),
                        ],
                      );
                    }

                    return Container();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
