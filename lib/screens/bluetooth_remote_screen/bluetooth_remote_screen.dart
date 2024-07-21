import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:smart_link/config/config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_link/common/common.dart';
import 'package:smart_link/screens/bluetooth_remote_screen/widgets/custom_joystick_stick.dart';
import 'package:smart_link/screens/bluetooth_remote_screen/cubit/bluetooth_remote_cubit.dart';

class BluetoothRemoteControlScreen extends StatefulWidget {
  final BluetoothDevice device;

  const BluetoothRemoteControlScreen({super.key, required this.device});

  @override
  State<BluetoothRemoteControlScreen> createState() =>
      _BluetoothRemoteControlScreenState();
}

class _BluetoothRemoteControlScreenState
    extends State<BluetoothRemoteControlScreen>
    with StandardAppWidgets, SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _establishConnection(widget.device);
  }

  Future<void> _establishConnection(BluetoothDevice device) async {
    final bluetooth = BlocProvider.of<BluetoothRemoteCubit>(context);
    await bluetooth.connect(device: device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<BluetoothRemoteCubit, BluetoothRemoteState>(
          builder: (context, state) {
            if (state is Connected) {
              return Text(state.message);
            }
            return const Text("Controller");
          },
        ),
        leading: BlocBuilder<BluetoothRemoteCubit, BluetoothRemoteState>(
          builder: (context, state) {
            if (state is Connected) {
              return IconButton(
                icon: const Icon(Icons.exit_to_app_rounded),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("Disconnect?"),
                        content: const Text(
                            "End communication with connected device?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () async {
                              await context
                                  .read<BluetoothRemoteCubit>()
                                  .disconnect();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }
            return IconButton(
              onPressed: () {
                showSnackBarWidget(
                  context,
                  "Ongoing operation cannot be interrupted!",
                );
              },
              icon: const Icon(Icons.exit_to_app_rounded),
            );
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: BlocConsumer<BluetoothRemoteCubit, BluetoothRemoteState>(
          listener: (context, state) {
            if (state is ConnectionFailed) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.bluetoothHome,
              );
              showSnackBarWidget(context, state.message);
            }

            if (state is Disconnected) {
              SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp],
              );

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.bluetoothHome,
                (route) => false,
              );
              showSnackBarWidget(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is Connecting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitWave(
                    color: const Color.fromARGB(255, 224, 224, 224),
                    size: 50.0,
                    controller: _animationController,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 20),
                  Text(
                    "Establishing connection with ${widget.device.name} . . .",
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }

            if (state is Connected) {
              SystemChrome.setPreferredOrientations(
                [DeviceOrientation.landscapeLeft],
              );
              return const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _RobotMovementController(),
                  _RobotCameraController(),
                ],
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}

// Robot Movement Controller
class _RobotMovementController extends StatefulWidget {
  const _RobotMovementController();

  @override
  State<_RobotMovementController> createState() =>
      _RobotMovementControllerState();
}

class _RobotMovementControllerState extends State<_RobotMovementController> {
  bool isJoystickIdle = true;

  @override
  Widget build(BuildContext context) {
    return Joystick(
      stick: const CustomJoystickStick(
        icon: Icon(
          Icons.api_rounded,
          color: Colors.white70,
        ),
      ),
      mode: JoystickMode.horizontalAndVertical,
      onStickDragEnd: () {
        log("Movement Joystick Idle!");
        isJoystickIdle = true;
        context.read<BluetoothRemoteCubit>().stopMovement();
        HapticFeedback.lightImpact();
      },
      listener: (details) {
        setState(() {
          if (details.y < 0 && isJoystickIdle) {
            log("Movement Joystick -Y: ${details.y}");
            isJoystickIdle = false;
            context.read<BluetoothRemoteCubit>().moveForward();
            HapticFeedback.lightImpact();
          }

          if (details.y > 0 && isJoystickIdle) {
            log("Movement Joystick Y: ${details.y}");
            isJoystickIdle = false;
            context.read<BluetoothRemoteCubit>().moveBackward();
            HapticFeedback.lightImpact();
          }

          if (details.x < 0 && isJoystickIdle) {
            log("Movement Joystick -X: ${details.x}");
            isJoystickIdle = false;
            context.read<BluetoothRemoteCubit>().moveLeft();
            HapticFeedback.lightImpact();
          }

          if (details.x > 0 && isJoystickIdle) {
            log("Movement Joystick X: ${details.x}");
            isJoystickIdle = false;
            context.read<BluetoothRemoteCubit>().moveRight();
            HapticFeedback.lightImpact();
          }
        });
      },
    );
  }
}

// Robot Camera Controller
class _RobotCameraController extends StatefulWidget {
  const _RobotCameraController();

  @override
  State<_RobotCameraController> createState() => _RobotCameraControllerState();
}

class _RobotCameraControllerState extends State<_RobotCameraController> {
  bool isJoystickIdle = true;

  @override
  Widget build(BuildContext context) {
    return Joystick(
      stick: const CustomJoystickStick(
        icon: Icon(
          Icons.radio_button_checked_rounded,
          color: Colors.white70,
        ),
      ),
      mode: JoystickMode.horizontalAndVertical,
      onStickDragEnd: () {
        log("Camera Joystick Idle!");
        isJoystickIdle = true;
        context.read<BluetoothRemoteCubit>().stopCamera();
        HapticFeedback.lightImpact();
      },
      listener: (details) {
        setState(() {
          if (details.y < 0 && isJoystickIdle) {
            log("Camera Joystick -Y: ${details.y}");
            isJoystickIdle = false;
            context.read<BluetoothRemoteCubit>().moveCameraAngleToUp();
            HapticFeedback.lightImpact();
          }

          if (details.y > 0 && isJoystickIdle) {
            log("Camera Joystick Y: ${details.y}");
            isJoystickIdle = false;
            context.read<BluetoothRemoteCubit>().moveCameraAngleToDown();
            HapticFeedback.lightImpact();
          }

          if (details.x < 0 && isJoystickIdle) {
            log("Joystick -X: ${details.x}");
            isJoystickIdle = false;
            context.read<BluetoothRemoteCubit>().moveCameraAngleToLeft();
            HapticFeedback.lightImpact();
          }

          if (details.x > 0 && isJoystickIdle) {
            log("Camera Joystick X: ${details.x}");
            isJoystickIdle = false;
            context.read<BluetoothRemoteCubit>().moveCameraAngleToRight();
            HapticFeedback.lightImpact();
          }
        });
      },
    );
  }
}
