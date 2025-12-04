import 'package:flutter/material.dart';

class FollowersSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const FollowersSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 381.26,
      height: 48,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Color(0xFF795548),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: 'Search followers...',
                hintStyle: TextStyle(
                  color: Color(0xFF795548),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
