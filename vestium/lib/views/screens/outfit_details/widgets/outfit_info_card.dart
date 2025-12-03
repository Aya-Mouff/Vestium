import 'package:flutter/material.dart';

class OutfitInfoCard extends StatelessWidget {
  final Map<String, dynamic> outfit;

  const OutfitInfoCard({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Outfit Name
          Text(
            outfit['name'] ?? 'Unnamed Outfit',
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 8),

          // Description
          if (outfit['description'] != null &&
              outfit['description'].toString().isNotEmpty)
            Text(
              outfit['description'],
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          const SizedBox(height: 16),

          // Created Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Color(0xFF795548),
              ),
              const SizedBox(width: 8),
              Text(
                outfit['createdDate'] ?? 'Created on October 20, 2025',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w200,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tags
          if (outfit['tags'] != null && (outfit['tags'] as List).isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.label_outline,
                  size: 16,
                  color: Color(0xFF795548),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (outfit['tags'] as List).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5ECE7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          tag.toString().startsWith('#') ? tag : '#$tag',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}