// lib/wardrobe_screen/widgets/wardrobe_item_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../cubit/wardrobe_cubit.dart';
import 'package:vestium/databases/db_models.dart';

class WardrobeItemCard extends StatelessWidget {
  final ItemModel item;

  const WardrobeItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemCategory>>(
      future: context.read<WardrobeCubit>().getCategoriesForItem(item.itemId!),
      builder: (context, snapshot) {
        final categories = snapshot.data ?? [];
        final categoryText = categories.isNotEmpty
            ? categories.map((c) => c.categoryName).join(', ')
            : 'No categories';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildImage(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.itemName ?? 'Unnamed Item',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              categoryText,
              style: TextStyle(fontSize: 12, color: Colors.brown.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage() {
    if (item.imagePath != null && item.imagePath!.isNotEmpty) {
      return Image.file(
        File(item.imagePath!),
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF0E4DC),
      child: const Center(
        child: Icon(
          Icons.photo,
          size: 40,
          color: Color(0xFF8B6B61),
        ),
      ),
    );
  }
}