// lib/wardrobe_screen/widgets/wardrobe_empty_state.dart
import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class WardrobeEmptyState extends StatelessWidget {
  final String selectedFilter;

  const WardrobeEmptyState({super.key, required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selectedFilter == loc.wardrobeAll ? Icons.inventory_2_outlined : Icons.filter_alt_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            selectedFilter == loc.wardrobeAll ? loc.wardrobeEmptyFull : loc.wardrobeEmptyCategory(selectedFilter),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            loc.wardrobeAddItem,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
