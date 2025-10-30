import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final String currentPage;
  const CustomNavBar({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 20, // Space from bottom of screen
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF795548),
          width: 0.25,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Image.asset(
              'assets/images/icons/Home Icon.png',
              color: currentPage == 'home' ? Colors.black: Color(0xFF795548),
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Auto route to home
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/icons/Search Icon.png',
              color: currentPage == 'search' ? Colors.black: Color(0xFF795548),
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Auto route to search
            },
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFD7CCC8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/images/icons/Add Icon.png',
                width: 24,
                height: 24,
                color: currentPage == 'add' ? Colors.black: Color(0xFF795548),
              ),
              onPressed: () {
                // Auto route to create post
              },
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/icons/Wardrobe Icon.png',
              color: currentPage == 'wardrobe' ? Colors.black: Color(0xFF795548),
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Auto route to favorites
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/icons/Profile Icon.png',
              color: currentPage == 'profile' ? Colors.black: Color(0xFF795548),
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Auto route to profile
            },
          ),
        ],
      ),
    );
  }
}