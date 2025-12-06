import 'package:flutter/material.dart';

class ManageCategories2AppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ManageCategories2AppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Manage Categories For Outfits',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'CormorantGaramond',
        ),
      ),
    );
  }
}
