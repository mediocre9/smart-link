import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/strings/app_strings.dart';

class RadarAnimation extends StatelessWidget {
  final String text;

  const RadarAnimation({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            AppStrings.radarAnimationPath,
            height: MediaQuery.of(context).size.height / 5,
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
          Text(
            text,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
