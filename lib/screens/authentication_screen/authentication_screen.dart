import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_button/sign_button.dart';
import 'package:smart_link/common/common.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/screens/authentication_screen/cubit/authentication_screen_cubit.dart';
import 'package:smart_link/screens/privacy_policy_screen.dart';

class AuthenticationScreen extends StatelessWidget with StandardAppWidgets {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppStrings.appLogo,
                    width: mediaQuery.size.width / 3,
                  ),
                  SizedBox(height: mediaQuery.size.height / 40),
                  Text(
                    AppStrings.appName,
                    style: theme.displaySmall!.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppStrings.appDescription,
                    style: theme.labelMedium,
                  ),
                  SizedBox(height: mediaQuery.size.height / 30),
                  BlocConsumer<AuthenticationScreenCubit,
                      AuthenticationScreenState>(
                    builder: _blocBuilders,
                    listener: _blocListeners,
                  ),
                  SizedBox(height: mediaQuery.size.height / 50),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  text: 'By signing in, you agree to our ',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blocBuilders(BuildContext context, AuthenticationScreenState state) {
    switch (state) {
      case Initial():
        return SignInButton(
          buttonType: ButtonType.googleDark,
          shape: const StadiumBorder(),
          buttonSize: ButtonSize.small,
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
          AppRoutes.bluetoothHome,
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
