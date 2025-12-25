import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class GalleryEmptyPage extends StatelessWidget {
  const GalleryEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(child: Text(loc.galleryEmptyMessage, textAlign: TextAlign.center));
  }
}
