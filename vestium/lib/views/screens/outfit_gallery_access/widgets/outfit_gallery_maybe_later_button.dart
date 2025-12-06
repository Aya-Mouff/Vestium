import 'package:flutter/material.dart';
import '../../gallery_access/widgets/gallery_maybe_later_button.dart';
class OutfitGalleryMaybeLaterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const OutfitGalleryMaybeLaterButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GalleryMaybeLaterButton(
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
