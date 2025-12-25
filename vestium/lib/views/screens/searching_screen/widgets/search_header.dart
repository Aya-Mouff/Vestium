import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final VoidCallback onClear;

  const SearchHeader({super.key, required this.controller, required this.isSearching, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      width: 412,
      height: 150,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.searchDiscoverTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'CormorantGaramond',
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF5ECE7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD7CCC8), width: 1),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(fontFamily: 'Inter', color: Colors.black),
              decoration: InputDecoration(
                hintText: loc.searchPlaceholder,
                hintStyle: const TextStyle(color: Color(0xFF795548), fontSize: 14, fontFamily: 'Inter'),
                prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF795548)),
                suffixIcon: isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20, color: Color(0xFF795548)),
                        onPressed: onClear,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
