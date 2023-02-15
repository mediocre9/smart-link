import 'package:flutter/material.dart';
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
  Color buttonColor = Colors.grey;
  @override
  void initState() {
    () async {
      await BlocProvider.of<RemoteCubit>(context).connect(widget.device);
    }();
    super.initState();
  }

  List<bool> robotControlButtons = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name!),
      ),
      body: SizedBox(
        height: mediaQuery.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<RemoteCubit, RemoteState>(
              builder: (context, state) {
                if (state is Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is Initial) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  robotControlButtons[0]
                                      ? Colors.blue
                                      : Colors.transparent)),
                          onPressed: () {
                            setState(() {
                              robotControlButtons
                                  .setAll(0, [true, false, false, false]);
                              context.read<RemoteCubit>().moveForward();
                            });
                          },
                          child: const Icon(Icons.arrow_circle_up_rounded),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    robotControlButtons[1]
                                        ? Colors.blue
                                        : Colors.transparent),
                              ),
                              onPressed: () {
                                setState(() {
                                  robotControlButtons
                                      .setAll(0, [false, true, false, false]);

                                  context.read<RemoteCubit>().moveLeft();
                                });
                              },
                              child:
                                  const Icon(Icons.arrow_circle_left_outlined),
                            ),
                            OutlinedButton(
                                child: const Icon(Icons.restart_alt_outlined),
                                onPressed: () {
                                  setState(() {
                                    robotControlButtons.setAll(
                                        0, [false, false, false, false]);
                                    context.read<RemoteCubit>().reset();
                                  });
                                }),
                            OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    robotControlButtons[2]
                                        ? Colors.blue
                                        : Colors.transparent),
                              ),
                              onPressed: () {
                                setState(() {
                                  robotControlButtons
                                      .setAll(0, [false, false, true, false]);
                                  context.read<RemoteCubit>().moveRight();
                                });
                              },
                              child:
                                  const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  robotControlButtons[3]
                                      ? Colors.blue
                                      : Colors.transparent)),
                          onPressed: () {
                            setState(() {
                              robotControlButtons
                                  .setAll(0, [false, false, false, true]);
                              context.read<RemoteCubit>().moveBackward();
                            });
                          },
                          child: const Icon(Icons.arrow_circle_down_outlined),
                        ),
                        const Text("Movement Controller"),
                        const Divider(),
                        GestureDetector(
                          onLongPressStart: (details) {
                            context.read<RemoteCubit>().moveCameraAngleToUp();
                          },
                          onLongPressEnd: (details) =>
                              context.read<RemoteCubit>().stopCamera(),
                          child: OutlinedButton(
                            style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.all(Colors.blue)),
                            onPressed: () {},
                            child: const Icon(
                                Icons.keyboard_double_arrow_up_rounded),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onLongPressStart: (details) {
                                context
                                    .read<RemoteCubit>()
                                    .moveCameraAngleToLeft();
                              },
                              onLongPressEnd: (details) =>
                                  context.read<RemoteCubit>().stopCamera(),
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Icon(
                                    Icons.keyboard_double_arrow_left_rounded),
                              ),
                            ),
                            GestureDetector(
                              onLongPressStart: (details) {
                                context
                                    .read<RemoteCubit>()
                                    .moveCameraAngleToRight();
                              },
                              onLongPressEnd: (details) =>
                                  context.read<RemoteCubit>().stopCamera(),
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Icon(
                                    Icons.keyboard_double_arrow_right_rounded),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onLongPressStart: (details) {
                            context.read<RemoteCubit>().moveCameraAngleToDown();
                          },
                          onLongPressEnd: (details) =>
                              context.read<RemoteCubit>().stopCamera(),
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Icon(
                                Icons.keyboard_double_arrow_down_rounded),
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height / 20),
                        const Text("Camera Controller")
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
