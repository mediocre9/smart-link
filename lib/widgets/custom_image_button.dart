import 'package:flutter/material.dart';

class CustomImageButton extends StatelessWidget {
  final Text label;
  final Image image;
  final void Function()? onPressed;

  const CustomImageButton({
    super.key,
    required this.label,
    required this.image,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        label: label,
        icon: CircleAvatar(
          maxRadius: 15,
          backgroundColor: Colors.white,
          child: image,
        ),
        style: ButtonStyle(
          // shape: MaterialStateProperty.all(
          //   RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(50),
          //   ),
          // ),
          // padding: MaterialStateProperty.all(
          //   const EdgeInsets.all(15),
          // ),
          backgroundColor: MaterialStateProperty.all(
            Colors.grey,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
