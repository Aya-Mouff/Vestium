import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class CaptionField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CaptionField({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDE8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        onChanged: onChanged,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
        decoration: InputDecoration(
          hintText: loc.captionPlaceholder,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14, fontFamily: 'Inter'),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
