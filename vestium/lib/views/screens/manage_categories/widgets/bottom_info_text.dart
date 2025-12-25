import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class BottomInfoText extends StatelessWidget {
  const BottomInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        loc.manageCategoriesInfo,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Color(0xFF795548), height: 1.3, fontFamily: 'Inter'),
      ),
    );
  }
}
