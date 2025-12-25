import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class PublicToggle extends StatelessWidget {
  final bool isPublic;
  final ValueChanged<bool> onChanged;

  const PublicToggle({super.key, required this.isPublic, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.public, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.publicPostLabel,
                  style: const TextStyle(fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w600),
                ),
                Text(
                  loc.publicPostDescription,
                  style: TextStyle(fontSize: 12, fontFamily: 'Inter', color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(value: isPublic, onChanged: onChanged, activeThumbColor: const Color(0xFF8B6B5C)),
        ],
      ),
    );
  }
}
