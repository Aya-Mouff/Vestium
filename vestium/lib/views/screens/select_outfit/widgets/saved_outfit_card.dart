// widgets/saved_outfit_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../databases/db_models.dart';

class SavedOutfitCard extends StatelessWidget {
  final OutfitModel outfit;
  final bool isSelected;
  final VoidCallback onTap;
  final String? imagePath; // resolved outside
  final String? date;      // raw date string

  const SavedOutfitCard({
    super.key,
    required this.outfit,
    required this.isSelected,
    required this.onTap,
    this.imagePath,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final String name = outfit.outfitName ?? 'Untitled Outfit';
    final String daysAgo = _computeDaysAgo(date);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: isSelected
              ? Border.all(color: const Color(0xFF8B6B5C), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: (isSelected ? const Color(0xFF8B6B5C) : Colors.black)
                  .withOpacity(isSelected ? 0.3 : 0.1),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: imagePath != null
                      ? Image.file(
                          File(imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _placeholder(),
                        )
                      : _placeholder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'CormorantGaramond',
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    daysAgo,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Inter',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _computeDaysAgo(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final created = DateTime.parse(rawDate);
      final diff = DateTime.now().difference(created);
      if (diff.inDays <= 0) return 'Today';
      if (diff.inDays == 1) return '1 day ago';
      if (diff.inDays < 7) return '${diff.inDays} days ago';
      final weeks = (diff.inDays / 7).floor();
      if (weeks == 1) return '1 week ago';
      return '$weeks weeks ago';
    } catch (_) {
      return '';
    }
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.checkroom,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
}
