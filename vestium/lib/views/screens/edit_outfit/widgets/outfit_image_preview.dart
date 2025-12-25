// import 'package:flutter/material.dart';

// class OutfitImagePreview extends StatelessWidget {
//   final String imageUrl;

//   const OutfitImagePreview({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       height: 360,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF795548).withValues(alpha: .15),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Image.asset(
//           imageUrl,
//           width: double.infinity,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               color: const Color(0xFFD7CCC8),
//               child: const Center(
//                 child: Icon(
//                   Icons.image_not_supported,
//                   size: 64,
//                   color: Color(0xFF795548),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// =====================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class OutfitImagePreview extends StatelessWidget {
  final String imageUrl;

  const OutfitImagePreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFF795548).withValues(alpha: .15), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(24), child: _buildImage()),
    );
  }

  Widget _buildImage() {
    // Check if the image URL is empty
    if (imageUrl.isEmpty) {
      print('⚠️ Image URL is empty');
      return _errorPlaceholder();
    }

    print('📸 Loading image from: $imageUrl');

    // Check if it's an asset image
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error loading asset image: $imageUrl - $error');
          return _errorPlaceholder();
        },
      );
    }

    // Otherwise, it's a file path from the file system
    try {
      final file = File(imageUrl);

      return FutureBuilder<bool>(
        future: file.exists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingPlaceholder();
          }

          if (snapshot.hasData && snapshot.data == true) {
            return Image.file(
              file,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('❌ Error loading file image: $imageUrl - $error');
                return _errorPlaceholder();
              },
            );
          } else {
            print('❌ File does not exist: $imageUrl');
            return _errorPlaceholder();
          }
        },
      );
    } catch (e) {
      print('❌ Exception loading image: $imageUrl - $e');
      return _errorPlaceholder();
    }
  }

  Widget _loadingPlaceholder() {
    return Container(
      color: const Color(0xFFE9D9CF),
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: const Color(0xFF795548).withValues(alpha: .6),
                    strokeWidth: 2.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  loc.editOutfitImageLoading,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF795548).withValues(alpha: .7),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      color: const Color(0xFFD7CCC8),
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported_rounded, size: 64, color: const Color(0xFF795548).withValues(alpha: .6)),
                const SizedBox(height: 12),
                Text(
                  loc.editOutfitImageNotAvailable,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF795548).withValues(alpha: .7),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
