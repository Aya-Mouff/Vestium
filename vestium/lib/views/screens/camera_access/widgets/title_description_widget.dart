import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class TitleDescriptionWidget extends StatelessWidget {
  const TitleDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          loc.cameraAccessTitle,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E2723),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          loc.cameraAccessDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w200,
            color: Color(0xFF795548),
            height: 1.6,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
