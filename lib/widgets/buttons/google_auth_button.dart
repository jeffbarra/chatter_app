import 'package:flutter/material.dart';

class GoogleAuthButton extends StatelessWidget {
  final String text;
  void Function()? onPressed;
  GoogleAuthButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.black)),
        icon: const Image(
          image: AssetImage(
            'lib/assets/images/google_logo.png',
          ),
          width: 30,
        ),
        onPressed: onPressed,
        label: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
