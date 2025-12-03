import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class OutfitDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String outfitId;

  const OutfitDetailsAppBar({super.key, required this.outfitId});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF3E2723)),
        onPressed: () => context.router.maybePop(),
      ),
      title: const Text(
        'Outfit Details',
        style: TextStyle(
          fontFamily: 'CormorantGaramond',
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Color(0xFF3E2723),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Color(0xFF3E2723)),
          onPressed: () {
            context.router.pushNamed('/edit-outfit/$outfitId');
          },
        ),
      ],
    );
  }
}