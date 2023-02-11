import 'dart:async';

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

  List<bool> buttons = [false, false, false, false];

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
                                  (buttons[0] == true && buttons[3] == false)
                                      ? Colors.blue
                                      : Colors.transparent)),
                          onPressed: buttons[0]
                              ? () {}
                              : () {
                                  setState(() {
                                    buttons[0] = true;
                                    buttons[3] = false;
                                    event.moveForward();
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
                                    buttons[1]
                                        ? Colors.blue
                                        : Colors.transparent),
                              ),
                              onPressed:
                                  (buttons[1] == true && buttons[2] == false)
                                      ? () {}
                                      : () {
                                          setState(() {
                                            buttons[1] = true;
                                            buttons[2] = false;
                                            event.moveLeft();
                                          });
                                        },
                              child:
                                  const Icon(Icons.arrow_circle_left_outlined),
                            ),
                            OutlinedButton(
                                child: const Icon(Icons.restart_alt_outlined),
                                onPressed: () {
                                  setState(() {
                                    buttons.setAll(
                                        0, [false, false, false, false]);
                                    event.reset();
                                  });
                                }),
                            OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    (buttons[2] == true && buttons[1] == false)
                                        ? Colors.blue
                                        : Colors.transparent),
                              ),
                              onPressed: buttons[2]
                                  ? () {}
                                  : () {
                                      setState(() {
                                        buttons[2] = true;
                                        buttons[1] = false;
                                        event.moveRight();
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
                                  (buttons[3] == true && buttons[0] == false)
                                      ? Colors.blue
                                      : Colors.transparent)),
                          onPressed: buttons[3]
                              ? () {}
                              : () {
                                  setState(() {
                                    buttons[3] = true;
                                    buttons[0] = false;
                                    event.moveBackward();
                                  });
                                },
                          child: const Icon(Icons.arrow_circle_down_outlined),
                        ),
                        const Text("Movement Controller"),
                        const Divider(),
                        OutlinedButton(
                          style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.blue)),
                          onPressed: () {
                            Timer.periodic(const Duration(milliseconds: 1),
                                (timer) {
                              setState(() {
                                event.moveCameraAngleToUp();
                              });
                            });
                          },
                          child: const Icon(
                              Icons.keyboard_double_arrow_up_rounded),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.all(Colors.blue)),
                              onPressed: () {
                                Timer.periodic(const Duration(milliseconds: 1),
                                    (timer) {
                                  setState(() {
                                    event.moveCameraAngleToLeft();
                                  });
                                });
                              },
                              child: const Icon(
                                  Icons.keyboard_double_arrow_left_rounded),
                            ),
                            OutlinedButton(
                              style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.all(Colors.blue)),
                              onPressed: () {
                                Timer.periodic(const Duration(milliseconds: 1),
                                    (timer) {
                                  setState(() {
                                    event.moveCameraAngleToRight();
                                  });
                                });
                              },
                              child: const Icon(
                                  Icons.keyboard_double_arrow_right_rounded),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.blue)),
                          onPressed: () {
                            Timer.periodic(const Duration(milliseconds: 1),
                                (timer) {
                              setState(() {
                                event.moveCameraAngleToDown();
                              });
                            });
                          },
                          child: const Icon(
                              Icons.keyboard_double_arrow_down_rounded),
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
