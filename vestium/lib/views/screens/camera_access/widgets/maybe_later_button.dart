import 'package:flutter/material.dart';

class MaybeLaterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MaybeLaterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
      child: const Text(
        'Maybe Later',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: Color(0xFF795548),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}