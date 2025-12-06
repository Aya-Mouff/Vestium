// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
// import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';

// class OutfitImagePreview extends StatelessWidget {
//   final CreateOutfitCubit createOutfitCubit;
  
//   const OutfitImagePreview({
//     super.key,
//     required this.createOutfitCubit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final createOutfitState = createOutfitCubit.state;
    
//     if (createOutfitState is! CreateOutfitItemsLoaded) {
//       return Container();
//     }
    
//     final placedItems = createOutfitState.placedItems;
    
//     return placedItems.isEmpty
//         ? const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.photo_library,
//                   size: 48,
//                   color: Color(0xFFA1887F),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'Outfit preview will be generated',
//                   style: TextStyle(
//                     fontFamily: 'inter',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w300,
//                     color: Color(0xFF795548),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : Stack(
//             children: placedItems.map((placedItem) {
//               return Positioned(
//                 left: placedItem.position.dx / 4,
//                 top: placedItem.position.dy / 4,
//                 child: Container(
//                   width: 60,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: const Color(0xFF795548).withValues(alpha: .3),
//                       width: 1,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: .1),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: _buildItemImage(placedItem.item.imagePath),
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//   }

//   Widget _buildItemImage(String? imagePath) {
//     if (imagePath != null && imagePath.isNotEmpty) {
//       return FutureBuilder<bool>(
//         future: _checkIfFileExists(imagePath),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               color: const Color(0xFFF5ECE7),
//               child: const Center(
//                 child: SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Color(0xFF795548),
//                   ),
//                 ),
//               ),
//             );
//           }

//           if (snapshot.data == true) {
//             return Image.file(
//               File(imagePath),
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: double.infinity,
//               errorBuilder: (context, error, stackTrace) {
//                 return _buildPlaceholder();
//               },
//             );
//           }

//           return _buildPlaceholder();
//         },
//       );
//     }
//     return _buildPlaceholder();
//   }

//   Widget _buildPlaceholder() {
//     return Container(
//       color: const Color(0xFFF5ECE7),
//       child: Center(
//         child: Icon(
//           Icons.photo,
//           size: 24,
//           color: const Color(0xFFA1887F).withValues(alpha: .5),
//         ),
//       ),
//     );
//   }

//   Future<bool> _checkIfFileExists(String path) async {
//     try {
//       final file = File(path);
//       return await file.exists();
//     } catch (e) {
//       return false;
//     }
//   }
// }

// ================================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';

class OutfitImagePreview extends StatelessWidget {
  final CreateOutfitCubit createOutfitCubit;
  
  const OutfitImagePreview({
    super.key,
    required this.createOutfitCubit,
  });

  @override
  Widget build(BuildContext context) {
    final createOutfitState = createOutfitCubit.state;
    
    if (createOutfitState is! CreateOutfitItemsLoaded) {
      return Container();
    }
    
    final placedItems = createOutfitState.placedItems;
    
    return Container(
      width: double.infinity,
      height: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF795548).withValues(alpha: .15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: placedItems.isEmpty
            ? Container(
                color: const Color(0xFFD7CCC8),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 48,
                        color: Color(0xFF795548),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Outfit preview will be generated',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(0xFF795548),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: placedItems.map((placedItem) {
                  return Positioned(
                    left: placedItem.position.dx / 4,
                    top: placedItem.position.dy / 4,
                    child: Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF795548).withValues(alpha: .3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildItemImage(placedItem.item.imagePath),
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }

  Widget _buildItemImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return FutureBuilder<bool>(
        future: _checkIfFileExists(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: const Color(0xFFD7CCC8),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF795548),
                ),
              ),
            );
          }

          if (snapshot.data == true) {
            return Image.file(
              File(imagePath),
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

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFD7CCC8),
      child: Center(
        child: Icon(
          Icons.photo,
          size: 32,
          color: const Color(0xFF795548).withValues(alpha: .5),
        ),
      ),
    );
  }

  Future<bool> _checkIfFileExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}