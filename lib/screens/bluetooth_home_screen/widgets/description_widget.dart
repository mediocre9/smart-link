import 'package:flutter/material.dart';

class DescriptionWidget extends StatelessWidget {
  final String text;
  final IconData icon;

  const DescriptionWidget({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: MediaQuery.of(context).size.width / 5,
          color: Colors.grey,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
