import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import '../../app_router.dart';

class CustomNavBar extends StatelessWidget {
  final String currentPage;
  final int userId;

  const CustomNavBar({super.key, required this.currentPage, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 20, // Space from bottom of screen
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xC0795548), width: 0.25),
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
            icon: Icon(
              Icons.home,
              color: currentPage == 'home'
                  ? Colors.black
                  : Color(0xC0795548), // change icon color
              size: 24,
            ),
            onPressed: () {
              context.pushRoute(  HomeRoute(userId: userId));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: currentPage == 'search'
                  ? Colors.black
                  : Color(0xC0795548), // change icon color
              size: 24,
            ),
            onPressed: () {
              context.pushRoute(SearchRoute(userId: userId));
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
              icon: Icon(
                Icons.add,
                color: currentPage == 'add'
                    ? Colors.black
                    : Color(0xC0795548), // change icon color
                size: 24,
              ),
              onPressed: () {
                context.pushRoute(OutfitCreatorRoute(userId: userId));
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.checkroom,
              color: currentPage == 'wardrobe'
                  ? Colors.black
                  : Color(0xC0795548), // change icon color
              size: 24,
            ),
            onPressed: () {
              context.pushRoute(WardrobeRoute(userId: userId));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: currentPage == 'profile'
                  ? Colors.black
                  : Color(0xC0795548), // change icon color
              size: 24,
            ),
            onPressed: () {
              context.pushRoute(MyProfileRoute(userId: userId));
            },
          ),
        ],
      ),
    );
  }
}
