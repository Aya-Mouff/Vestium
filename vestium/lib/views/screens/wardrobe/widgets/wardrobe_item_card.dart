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
import '../cubit/wardrobe_cubit.dart';
import 'package:vestium/databases/db_models.dart';

class WardrobeItemCard extends StatelessWidget {
  final ItemModel item;

  const WardrobeItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemCategory>>(
      future: context.read<WardrobeCubit>().getCategoriesForItem(item.itemId!),
      builder: (context, snapshot) {
        final categories = snapshot.data ?? [];
        // Show up to 2 categories (matches your design better)
        final categoryText = categories.isNotEmpty
            ? categories.take(2).map((c) => c.categoryName ?? '').where((name) => name.isNotEmpty).join(', ')
            : 'No category';

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), // Reduced from 24
            color: const Color(0xFFFFFFFF),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF795548).withValues(alpha: .1),
                blurRadius: 4, // Reduced from 8
                offset: const Offset(0, 2), // Reduced from 4
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section - reduced height
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: SizedBox(
                  height: 215,
                  width: double.infinity,
                  child: _buildImage(),
                ),
              ),
              
              // Text section - reduced padding
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item name
                    Text(
                      item.itemName ?? 'Unnamed Item',
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 14, // Kept same
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3E2723),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 2), // Reduced spacing
                    
                    // Category
                    Text(
                      categoryText,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 8, // Slightly smaller
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF795548),
                        letterSpacing: 0.1, // Reduced
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
    );
  }

  Widget _buildImage() {
    if (item.imagePath != null && item.imagePath!.isNotEmpty) {
      // SIMPLIFIED VERSION - Fix the logic error
      return FutureBuilder<bool>(
        future: _checkIfFileExists(item.imagePath!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildImagePlaceholder();
          }
          
          // FIXED: Check if file exists
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
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Color(0xFF795548),
          ),
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
          size: 24, // Reduced
          color: const Color(0xFFA1887F).withValues(alpha: .5),
        ),
      ),
    );
  }
}