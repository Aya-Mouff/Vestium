// // lib/wardrobe_screen/widgets/wardrobe_item_card.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:io';
// import '../cubit/wardrobe_cubit.dart';
// import 'package:vestium/databases/db_models.dart';

// class WardrobeItemCard extends StatelessWidget {
//   final ItemModel item;

//   const WardrobeItemCard({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ItemCategory>>(
//       future: context.read<WardrobeCubit>().getCategoriesForItem(item.itemId!),
//       builder: (context, snapshot) {
//         final categories = snapshot.data ?? [];
//         final categoryText = categories.isNotEmpty
//             ? categories.map((c) => c.categoryName).join(', ')
//             : 'No categories';

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: _buildImage(),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               item.itemName ?? 'Unnamed Item',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(
//               categoryText,
//               style: TextStyle(fontSize: 12, color: Colors.brown.shade600),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildImage() {
//     if (item.imagePath != null && item.imagePath!.isNotEmpty) {
//       return Image.file(
//         File(item.imagePath!),
//         fit: BoxFit.cover,
//         width: double.infinity,
//         errorBuilder: (context, error, stackTrace) {
//           return _buildPlaceholder();
//         },
//       );
//     }
//     return _buildPlaceholder();
//   }

//   Widget _buildPlaceholder() {
//     return Container(
//       color: const Color(0xFFF0E4DC),
//       child: const Center(
//         child: Icon(
//           Icons.photo,
//           size: 40,
//           color: Color(0xFF8B6B61),
//         ),
//       ),
//     );
//   }
// }

// ============================================================================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/wardrobe_cubit.dart';
import 'package:vestium/databases/db_models.dart';

class WardrobeItemCard extends StatelessWidget {
  final ItemModel item;

  const WardrobeItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive sizes
    final imageHeight = screenWidth * 0.8;
    final cardPadding = screenWidth * 0.02;
    final itemNameFontSize = screenWidth * 0.035;
    final categoryFontSize = screenWidth * 0.025;

    return GestureDetector(
      onTap: () async {
        if (item.itemId != null) {
          final result = await context.router.push(EditItemDetailsRoute(itemId: item.itemId!));

          if (result == true && context.mounted) {
            context.read<WardrobeCubit>().refresh();
          }
        }
      },
      child: FutureBuilder<List<ItemCategory>>(
        future: context.read<WardrobeCubit>().getCategoriesForItem(item.itemId!),
        builder: (context, snapshot) {
          final loc = AppLocalizations.of(context)!;
          final categories = snapshot.data ?? [];
          final categoryText = categories.isNotEmpty
              ? categories.take(2).map((c) => c.categoryName ?? '').where((name) => name.isNotEmpty).join(', ')
              : loc.wardrobeNoCategory;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.04), // 4% of screen width
              color: const Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF795548).withValues(alpha: .1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.04),
                    topRight: Radius.circular(screenWidth * 0.04),
                  ),
                  child: SizedBox(height: imageHeight, width: double.infinity, child: _buildImage()),
                ),

                // Text section
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    cardPadding * 1.5, // Left
                    cardPadding * 1.5, // Top
                    cardPadding * 1.5, // Right
                    0, // Bottom
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Item name
                      Text(
                        item.itemName ?? loc.wardrobeUnnamedItem,
                        style: TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontSize: itemNameFontSize.clamp(12, 16), // Min 12, Max 16
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF3E2723),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: cardPadding * 0.2),

                      // Category
                      Text(
                        categoryText,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: categoryFontSize.clamp(10, 12), // Min 10, Max 12
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF795548),
                          letterSpacing: 0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage() {
    if (item.imagePath != null && item.imagePath!.isNotEmpty) {
      return FutureBuilder<bool>(
        future: _checkIfFileExists(item.imagePath!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildImagePlaceholder();
          }

          if (snapshot.data == true) {
            return Image.file(
              File(item.imagePath!),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder();
              },
            );
          }

          return _buildPlaceholder();
        },
      );
    }
    return _buildPlaceholder();
  }

  Future<bool> _checkIfFileExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFF5ECE7),
      child: const Center(
        child: SizedBox(
          width: 24, // Fixed but reasonable
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF795548)),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5ECE7),
      child: Center(
        child: Icon(
          Icons.photo,
          size: 32, // Slightly larger but fixed
          color: const Color(0xFFA1887F).withValues(alpha: .5),
        ),
      ),
    );
  }
}
