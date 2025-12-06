import 'package:flutter/material.dart';

class ManageCategories2BottomText extends StatelessWidget {
  const ManageCategories2BottomText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Categories help you organize your wardrobe items. Items can belong to multiple categories.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: Color(0xFF795548),
          height: 1.3,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
