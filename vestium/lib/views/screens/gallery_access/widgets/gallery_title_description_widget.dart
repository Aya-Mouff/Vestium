import 'package:flutter/material.dart';

class GalleryTitleDescriptionWidget extends StatelessWidget {
  const GalleryTitleDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Gallery Access',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E2723),
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Vestium needs access to your gallery to pic pictures of your clothing items and add them to your virtual wardrobe.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF795548),
            height: 1.5,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}