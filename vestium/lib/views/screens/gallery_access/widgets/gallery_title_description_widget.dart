import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class GalleryTitleDescriptionWidget extends StatelessWidget {
  const GalleryTitleDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          loc.galleryAccessTitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E2723),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          loc.galleryAccessDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF795548),
            height: 1.5,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
