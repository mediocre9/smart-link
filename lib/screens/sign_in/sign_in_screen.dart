import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remo_tooth/config/app_routes.dart';
import 'package:remo_tooth/screens/sign_in/cubit/sign_in_cubit.dart';

import '../../config/app_strings.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      bottomSheet: const Padding(
        padding: EdgeInsets.all(14),
        child: Text(
          'Copyright (c) ${AppString.DEVELOPER} 2023. All rights reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppString.LOGO,
              height: MediaQuery.of(context).size.height / 6,
            ),
            const Text(
              AppString.APP_NAME,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            const Text(
              AppString.DESCRIPTION,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.size.height / 50),
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
                  ScaffoldMessenger.of(_).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (_, state) {
                if (state is Initial) {
                  return ElevatedButton.icon(
                    label: const Text(AppString.GOOGLE_SIGN_IN_BTN),
                    icon: const Icon(FontAwesomeIcons.google),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blueGrey,
                      ),
                    ),
                    onPressed: () => BlocProvider.of<SignInCubit>(_).signIn(),
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
}
