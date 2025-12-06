import 'package:flutter/material.dart';
import '../../gallery_access/widgets/gallery_allow_access_button.dart';
class OutfitGalleryAllowAccessButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const OutfitGalleryAllowAccessButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GalleryAllowAccessButton(
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
