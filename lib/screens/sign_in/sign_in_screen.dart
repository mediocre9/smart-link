import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remo_tooth/config/app_strings.dart';
import 'package:remo_tooth/screens/sign_in/cubit/sign_in_cubit.dart';

import '../../config/app_routes.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var mediaQuery = MediaQuery.of(context);
    var event = BlocProvider.of<SignInCubit>(context);

    return Scaffold(
      bottomSheet: Text(
        AppString.COPYRIGHT,
        style: theme.labelSmall,
        textAlign: TextAlign.center,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppString.APP_NAME, style: theme.displayMedium),
            Text(AppString.APP_DESCRIPTION, style: theme.titleSmall),
            SizedBox(height: mediaQuery.size.height / 20),
            BlocConsumer<SignInCubit, SignInState>(
              listener: (_, state) {
                if (state is Authenticated) {
                  Navigator.pushNamedAndRemoveUntil(
                    _,
                    AppRoute.HOME,
                    (route) => false,
                    arguments: state.userCredential,
                  );
                } else if (state is Success) {
                  ScaffoldMessenger.of(_).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is Error) {
                  _showSnackBar(state.message, context);
                } else if (state is NoInternet) {
                  _showSnackBar(state.message, context);
                }
              },
              builder: (_, state) {
                if (state is Initial) {
                  return ElevatedButton.icon(
                    icon: Image.asset(AppString.GOOGLE_LOGO_IMAGE),
                    label: const Text(AppString.GOOGLE_LABEL_BUTTON),
                    onPressed: () => event.signIn(),
                  );
                } else if (state is Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
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

  void _showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
