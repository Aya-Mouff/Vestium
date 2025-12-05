// lib/wardrobe_screen/widgets/wardrobe_empty_state.dart
import 'package:flutter/material.dart';

class WardrobeEmptyState extends StatelessWidget {
  final String selectedFilter;

  const WardrobeEmptyState({super.key, required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selectedFilter == 'All'
                ? Icons.inventory_2_outlined
                : Icons.filter_alt_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            selectedFilter == 'All'
                ? 'Your wardrobe is empty'
                : 'No items in "$selectedFilter" category',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to add your first item',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}