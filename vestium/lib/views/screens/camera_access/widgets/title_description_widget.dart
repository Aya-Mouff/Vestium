import 'package:flutter/material.dart';

class TitleDescriptionWidget extends StatelessWidget {
  const TitleDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Camera Access',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E2723),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Vestium needs access to your camera to capture photos of your clothing items and add them to your virtual wardrobe.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w200,
            color: Color(0xFF795548),
            height: 1.6,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}