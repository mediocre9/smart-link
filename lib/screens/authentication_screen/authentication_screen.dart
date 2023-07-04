import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remo_tooth/widgets/common.dart';
import 'package:sign_button/sign_button.dart';
import '../../config/index.dart';
import '../authentication_screen/cubit/authentication_screen_cubit.dart';

class AuthenticationScreen extends StatelessWidget with StandardAppWidgets {
  const AuthenticationScreen({super.key});

  // @override
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
              AppString.kAppLogoPath,
              width: mediaQuery.size.width / 3,
            ),
            SizedBox(height: mediaQuery.size.height / 40),
            Text(
              AppString.kAppName,
              style: theme.displaySmall!.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(AppString.kAppDescription, style: theme.labelMedium),
            SizedBox(height: mediaQuery.size.height / 30),
            BlocConsumer<AuthenticationScreenCubit, AuthenticationScreenState>(
              listener: (_, state) {
                if (state is Authenticated) {
                  Navigator.pushNamedAndRemoveUntil(
                    _,
                    Routes.kBluetooth,
                    (route) => false,
                  );
                } else if (state is Success) {
                  ScaffoldMessenger.of(_).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is Error) {
                  showSnackBarWidget(context, state.message);
                } else if (state is NoInternet) {
                  showSnackBarWidget(context, state.message);
                }
              },
              builder: (_, state) {
                if (state is Initial) {
                  return SignInButton(
                    buttonType: ButtonType.googleDark,
                    shape: const BeveledRectangleBorder(),
                    onPressed: () {
                      context.read<AuthenticationScreenCubit>().signIn();
                    },
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
