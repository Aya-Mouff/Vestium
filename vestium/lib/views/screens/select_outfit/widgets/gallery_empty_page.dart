import 'package:flutter/material.dart';

class GalleryEmptyPage extends StatelessWidget {
  const GalleryEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Gallery will appear here once access is managed.',
        textAlign: TextAlign.center,
      ),
    );
  }
}
