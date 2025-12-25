// import 'package:flutter/material.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:vestium/app_router.dart';
// import 'dart:io';

// class OutfitsGrid extends StatelessWidget {
//   final List<dynamic> outfits;
//   final int userId;

//   const OutfitsGrid({super.key, required this.outfits, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     if (outfits.isEmpty) {
//       return SizedBox(
//         height: 200,
//         child: Center(
//           child: Text(
//             'No outfits yet',
//             style: TextStyle(color: Colors.grey.shade600),
//           ),
//         ),
//       );
//     }

//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: outfits.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 10,
//         crossAxisSpacing: 10,
//         childAspectRatio: 1,
//       ),
//       itemBuilder: (context, index) {
//         final outfit = outfits[index];
//         final imagePath = outfit['imageUrl'];

//         return GestureDetector(
//           onTap: () => context.pushRoute(EditOutfitRoute(outfitId: outfit['id'])),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: _buildOutfitImage(imagePath),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildOutfitImage(String imagePath) {
//     if (imagePath.startsWith('assets/')) {
//       // Asset image
//       return Image.asset(
//         imagePath,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return Container(
//             color: const Color(0xFFE9D9CF),
//             child: const Center(
//               child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 40),
//             ),
//           );
//         },
//       );
//     } else {
//       // File image
//       return Image.file(
//         File(imagePath),
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return Container(
//             color: const Color(0xFFE9D9CF),
//             child: const Center(
//               child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 40),
//             ),
//           );
//         },
//       );
//     }
//   }
// }

// =======================================

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/l10n/app_localizations.dart';
import 'dart:io';

class OutfitsGrid extends StatelessWidget {
  final List<dynamic> outfits;
  final int userId;
  final Function(int)? onOutfitTap;

  const OutfitsGrid({super.key, required this.outfits, required this.userId, this.onOutfitTap});

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(loc.myProfileNoOutfitsYet, style: TextStyle(color: Colors.grey.shade600)),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: outfits.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final outfit = outfits[index];
        final imagePath = outfit['imageUrl'] ?? '';

        // Try to get outfit ID from different possible keys
        final outfitId = outfit['outfit_id'] ?? outfit['id'];

        return GestureDetector(
          onTap: () {
            if (outfitId == null) {
              print('⚠️ Warning: Outfit ID is null for outfit at index $index');
              return;
            }

            if (onOutfitTap != null) {
              // Use callback if provided (preferred for auto-refresh)
              onOutfitTap!(outfitId);
            } else {
              // Fallback to direct navigation
              context.pushRoute(EditOutfitRoute(outfitId: outfitId));
            }
          },
          child: ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildOutfitImage(imagePath)),
        );
      },
    );
  }

  Widget _buildOutfitImage(String imagePath) {
    // Handle empty path
    if (imagePath.isEmpty) {
      return Container(
        color: const Color(0xFFE9D9CF),
        child: const Center(child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 40)),
      );
    }

    // Handle asset images
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFE9D9CF),
            child: const Center(child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 40)),
          );
        },
      );
    }

    // Handle file images
    return FutureBuilder<bool>(
      future: File(imagePath).exists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: const Color(0xFFE9D9CF),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF7B5247)),
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          return Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFE9D9CF),
                child: const Center(child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 40)),
              );
            },
          );
        }

        // File doesn't exist
        return Container(
          color: const Color(0xFFE9D9CF),
          child: const Center(child: Icon(Icons.broken_image, color: Color(0xFF7B5247), size: 40)),
        );
      },
    );
  }
}
