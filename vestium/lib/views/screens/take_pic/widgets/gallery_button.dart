import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vestium/app_router.dart';

class GalleryButton extends StatelessWidget {
  const GalleryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openGallery(context),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFD7CCC8),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.photo_library_outlined,
          color: Color(0xFF795548),
          size: 24,
        ),
      ),
    );
  }

  Future<void> _openGallery(BuildContext context) async {
    // Check current permission status
    final status = await Permission.photos.status;
    
    if (status.isGranted || status.isLimited) {
      // Permission already granted - navigate to SelectOutfitScreen
      if (context.mounted) {
        context.router.push(const SelectItemRoute());
      }
    } else {
      // Permission not granted - navigate to GalleryAccessScreen
      if (context.mounted) {
        context.router.push(const GalleryAccessRoute());
      }
    }
  }
}