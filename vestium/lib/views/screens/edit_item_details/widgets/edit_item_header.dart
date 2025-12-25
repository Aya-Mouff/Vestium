// lib/edit_item_details_screen/widgets/edit_item_header.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/l10n/app_localizations.dart';

class EditItemHeader extends StatelessWidget {
  const EditItemHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.router.maybePop(),
            child: const Icon(Icons.close, color: Color(0xFF3E2723), size: 24),
          ),
          Expanded(
            child: Text(
              loc.editItemDetailsTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3E2723),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}
