import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/common/common.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/screens/wifi_home_screen/cubit/wifi_home_cubit.dart';
import 'package:smart_link/services/auth_service.dart';

class WifiHomeScreen extends StatefulWidget {
  final IAuthenticationService authService;
  const WifiHomeScreen({super.key, required this.authService});

  @override
  State<WifiHomeScreen> createState() => _WifiHomeScreenState();
}

class _WifiHomeScreenState extends State<WifiHomeScreen>
    with StandardAppWidgets {
  @override
  void initState() {
    super.initState();
    widget.authService.isRevoked().then((blocked) {
      if (blocked) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.auth,
          (context) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Smart Lock"),
          actions: [
            popupMenuButtonWidget(context),
          ],
        ),
        drawer: AppDrawer(),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<WifiHomeCubit, WifiHomeState>(
                builder: _blocBuilders,
                listener: _blocListeners,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _biometricAuthButton(
    BuildContext context,
    Future<void> Function()? cb,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.fingerprint_rounded,
              size: MediaQuery.of(context).size.height / 5,
              color: Colors.grey,
            ),
            onPressed: cb != null ? () async => await cb() : null,
          ),
          const Text(
            "Tap to start Authentication process",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _blocBuilders(BuildContext context, WifiHomeState state) {
    switch (state) {
      case Initial():
        return _biometricAuthButton(
          context,
          context.read<WifiHomeCubit>().connectToDevice,
        );

      case Connecting():
        return _biometricAuthButton(context, null);

      default:
        return Container();
    }
  }

  void _blocListeners(BuildContext context, WifiHomeState state) {
    switch (state) {
      case BiometricError():
        showSnackBarWidget(context, state.message);
        break;

      case NetworkError():
        showSnackBarWidget(context, state.message);
        break;

      case NotConnected():
        showSnackBarWidget(context, state.message);
        break;

      case Unlock():
        showSnackBarWidget(context, state.message);
        break;

      default:
    }
  }
}
