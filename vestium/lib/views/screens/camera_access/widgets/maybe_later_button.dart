import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class MaybeLaterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MaybeLaterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
      child: Text(
        loc.cameraAccessMaybeLater,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: Color(0xFF795548),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
