import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class FollowingSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const FollowingSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: 381.26,
      height: 48,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[400], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontFamily: 'Inter'),
              decoration: InputDecoration(
                hintText: loc.followingSearchHint,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14, fontFamily: 'Inter'),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
