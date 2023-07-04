import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/strings/app_strings.dart';

class RadarAnimation extends StatelessWidget {
  final String text;
  final MediaQueryData mediaQuery;
  final ThemeData theme;

  const RadarAnimation({
    super.key,
    required this.mediaQuery,
    required this.theme,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            AppString.kRadarAnimationPath,
            height: mediaQuery.size.height / 5,
          ),
          SizedBox(height: mediaQuery.size.height / 20),
          Text(
            text,
            style: theme.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
