import 'package:flutter/material.dart';

class InitialHomeScreen extends StatelessWidget {
  final String text;
  final IconData icon;

  const InitialHomeScreen({
    super.key,
    // required this.mediaQuery,
    // required this.theme,
    required this.text,
    required this.icon,
  });

  // final MediaQueryData mediaQuery;
  // final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            icon,
            size: MediaQuery.of(context).size.width / 5,
            color: Colors.grey,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
