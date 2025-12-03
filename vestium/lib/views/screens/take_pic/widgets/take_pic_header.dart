import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class TakePicHeader extends StatelessWidget {
  const TakePicHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.router.maybePop();
            },
            child: const Icon(
              Icons.close,
              color: Color(0xFF3E2723),
              size: 24,
            ),
          ),
          const Expanded(
            child: Text(
              'Add Item',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3E2723),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}