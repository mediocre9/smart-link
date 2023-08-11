import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/widgets/common.dart';
import 'package:sign_button/sign_button.dart';
import '../../config/index.dart';
import '../authentication_screen/cubit/authentication_screen_cubit.dart';

class AuthenticationScreen extends StatelessWidget with StandardAppWidgets {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Strings.appLogo,
              width: mediaQuery.size.width / 3,
            ),
            SizedBox(height: mediaQuery.size.height / 40),
            Text(
              Strings.appName,
              style: theme.displaySmall!.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(Strings.appDescription, style: theme.labelMedium),
            SizedBox(height: mediaQuery.size.height / 30),
            BlocConsumer<AuthenticationScreenCubit, AuthenticationScreenState>(
              builder: _blocBuilders,
              listener: _blocListeners,
            ),
          ],
        ),
      ),
    );
  }

  Widget _blocBuilders(BuildContext context, AuthenticationScreenState state) {
    switch (state) {
      case Initial():
        return SignInButton(
          buttonType: ButtonType.googleDark,
          shape: const BeveledRectangleBorder(),
          onPressed: () => context.read<AuthenticationScreenCubit>().signIn(),
        );

      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  void _blocListeners(BuildContext context, AuthenticationScreenState state) {
    switch (state) {
      case Authenticated():
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.bluetoothHome,
          (route) => false,
        );
        showSnackBarWidget(context, state.message);
        break;

      case UserBlocked():
        showSnackBarWidget(context, state.message);
        break;

      case NoInternet():
        showSnackBarWidget(context, state.message);
        break;
      default:
    }
  }
}
