import 'package:flutter/material.dart';

class CustomJoystickStick extends StatelessWidget {
  final Icon icon;
  const CustomJoystickStick({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightBlue.shade900,
            Colors.lightBlue.shade400,
          ],
        ),
      ),
      child: Center(child: icon),
    );
  }
}
