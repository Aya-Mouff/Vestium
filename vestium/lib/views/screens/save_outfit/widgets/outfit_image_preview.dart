// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // ⭐ ADD THIS IMPORT
// import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
// import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';
// import 'package:vestium/views/screens/save_outfit/cubit/save_outfit_cubit.dart'; // ⭐ ADD THIS IMPORT
// import 'package:vestium/views/screens/save_outfit/cubit/save_outfit_state.dart'; // ⭐ ADD THIS IMPORT

// class OutfitImagePreview extends StatelessWidget {
//   final CreateOutfitCubit createOutfitCubit;

//   const OutfitImagePreview({super.key, required this.createOutfitCubit});

//   @override
//   Widget build(BuildContext context) {
//     // ⭐ USE BlocBuilder TO GET IMAGE FROM SaveOutfitCubit STATE
//     return BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
//       builder: (context, saveOutfitState) {
//         final createOutfitState = createOutfitCubit.state;

//         if (createOutfitState is! CreateOutfitItemsLoaded) {
//           return Container();
//         }

//         final placedItems = createOutfitState.placedItems;

//         // ⭐ GET IMAGE PATH FROM SaveOutfitCubit STATE
//         String? savedImagePath;
//         if (saveOutfitState is SaveOutfitDataLoaded) {
//           savedImagePath = saveOutfitState.preCapturedImagePath;
//           print('🖼️ OutfitImagePreview: Got image from SaveOutfitCubit state: $savedImagePath');
//         }

//         // Use the same dimensions as your create outfit canvas
//         final canvasWidth = 400.0;
//         final canvasHeight = 600.0;

//         return Container(
//           width: double.infinity,
//           height: 340,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF795548).withValues(alpha: .15),
//                 blurRadius: 20,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(24),
//             child: placedItems.isEmpty
//                 ? _buildEmptyPreview()
//                 : _buildPreview(
//                     savedImagePath, // ⭐ PASS THE SAVED IMAGE PATH
//                     placedItems,
//                     canvasWidth,
//                     canvasHeight,
//                   ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildEmptyPreview() {
//     return Container(
//       color: const Color(0xFFD7CCC8),
//       child: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.photo_library,
//               size: 48,
//               color: Color(0xFF795548),
//             ),
//             SizedBox(height: 12),
//             Text(
//               'Outfit preview will be generated',
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 14,
//                 color: Color(0xFF795548),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ⭐ NEW METHOD: CHOOSE BETWEEN SAVED IMAGE OR RECONSTRUCTION
//   Widget _buildPreview(
//     String? savedImagePath,
//     List<PlacedItemModel> placedItems,
//     double canvasWidth,
//     double canvasHeight,
//   ) {
//     // ⭐ PREFER THE SAVED IMAGE IF AVAILABLE AND VALID
//     if (savedImagePath != null && savedImagePath.isNotEmpty) {
//       return FutureBuilder<bool>(
//         future: _checkIfFileExists(savedImagePath),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildLoadingPreview();
//           }

//           if (snapshot.data == true) {
//             print('✅ OutfitImagePreview: Using saved image: $savedImagePath');
//             return Image.file(
//               File(savedImagePath),
//               fit: BoxFit.contain, // Use 'contain' to show whole image
//               width: double.infinity,
//               height: double.infinity,
//               errorBuilder: (context, error, stackTrace) {
//                 print('❌ OutfitImagePreview: Error loading saved image: $error');
//                 print('   Falling back to reconstructed preview');
//                 return _buildReconstructedPreview(
//                   placedItems,
//                   canvasWidth,
//                   canvasHeight,
//                 );
//               },
//             );
//           }

//           print('⚠️ OutfitImagePreview: Saved image file not found');
//           return _buildReconstructedPreview(
//             placedItems,
//             canvasWidth,
//             canvasHeight,
//           );
//         },
//       );
//     }

//     print('ℹ️ OutfitImagePreview: No saved image, reconstructing');
//     return _buildReconstructedPreview(
//       placedItems,
//       canvasWidth,
//       canvasHeight,
//     );
//   }

//   Widget _buildLoadingPreview() {
//     return Container(
//       color: Colors.white,
//       child: const Center(
//         child: CircularProgressIndicator(color: Color(0xFF795548)),
//       ),
//     );
//   }

//   // ⭐ EXTRACTED RECONSTRUCTION LOGIC
//   Widget _buildReconstructedPreview(
//     List<PlacedItemModel> placedItems,
//     double canvasWidth,
//     double canvasHeight,
//   ) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // Calculate scale factor to fit items in preview
//         final scaleX = constraints.maxWidth / canvasWidth;
//         final scaleY = constraints.maxHeight / canvasHeight;
//         final scale = scaleX < scaleY ? scaleX : scaleY;

//         return Container(
//           color: Colors.white,
//           child: Stack(
//             children: placedItems.map((placedItem) {
//               // Scale positions and sizes from original canvas
//               final scaledLeft = placedItem.position.dx * scale;
//               final scaledTop = placedItem.position.dy * scale;
//               final scaledWidth = placedItem.width * placedItem.scale * scale;
//               final scaledHeight = placedItem.height * placedItem.scale * scale;

//               return Positioned(
//                 left: scaledLeft,
//                 top: scaledTop,
//                 child: SizedBox(
//                   width: scaledWidth,
//                   height: scaledHeight,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: const Color(0xFF795548).withValues(alpha: .3),
//                         width: 1,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withValues(alpha: .1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: _buildItemImage(placedItem.item.imagePath),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildItemImage(String? imagePath) {
//     if (imagePath != null && imagePath.isNotEmpty) {
//       return FutureBuilder<bool>(
//         future: _checkIfFileExists(imagePath),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               color: const Color(0xFFD7CCC8),
//               child: const Center(
//                 child: CircularProgressIndicator(color: Color(0xFF795548)),
//               ),
//             );
//           }

//           if (snapshot.data == true) {
//             return Image.file(
//               File(imagePath),
//               fit: BoxFit.fitWidth,
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
//       color: const Color(0xFFD7CCC8),
//       child: Center(
//         child: Icon(
//           Icons.photo,
//           size: 32,
//           color: const Color(0xFF795548).withValues(alpha: .5),
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

// -------------------------------------------------------------------------

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';
import 'package:vestium/views/screens/save_outfit/cubit/save_outfit_cubit.dart';
import 'package:vestium/views/screens/save_outfit/cubit/save_outfit_state.dart';

class OutfitImagePreview extends StatelessWidget {
  final CreateOutfitCubit createOutfitCubit;

  const OutfitImagePreview({super.key, required this.createOutfitCubit});

  @override
  Widget build(BuildContext context) {
    // ⭐ FIX: Use BlocSelector to only rebuild when image path changes
    return BlocSelector<SaveOutfitCubit, SaveOutfitState, String?>(
      selector: (state) {
        // Extract ONLY the image path from state
        if (state is SaveOutfitDataLoaded) {
          return state.preCapturedImagePath;
        }
        return null;
      },
      builder: (context, savedImagePath) {
        return _OutfitImagePreviewContent(
          createOutfitCubit: createOutfitCubit,
          savedImagePath: savedImagePath,
        );
      },
    );
  }
}

// ⭐ FIX: Separate widget to prevent unnecessary rebuilds
class _OutfitImagePreviewContent extends StatelessWidget {
  final CreateOutfitCubit createOutfitCubit;
  final String? savedImagePath;

  const _OutfitImagePreviewContent({
    required this.createOutfitCubit,
    required this.savedImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final createOutfitState = createOutfitCubit.state;

    if (createOutfitState is! CreateOutfitItemsLoaded) {
      return Container();
    }

    final placedItems = createOutfitState.placedItems;

    // Use the same dimensions as your create outfit canvas
    final canvasWidth = 400.0;
    final canvasHeight = 600.0;

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
            : LayoutBuilder(
                builder: (context, constraints) {
                  // ⭐ FIX: Cache the expensive computation
                  return _PreviewImage(
                    savedImagePath: savedImagePath,
                    placedItems: placedItems,
                    constraints: constraints,
                    canvasWidth: canvasWidth,
                    canvasHeight: canvasHeight,
                  );
                },
              ),
      ),
    );
  }
}

// ⭐ FIX: Stateful widget to cache the image
class _PreviewImage extends StatefulWidget {
  final String? savedImagePath;
  final List<PlacedItemModel> placedItems;
  final BoxConstraints constraints;
  final double canvasWidth;
  final double canvasHeight;

  const _PreviewImage({
    required this.savedImagePath,
    required this.placedItems,
    required this.constraints,
    required this.canvasWidth,
    required this.canvasHeight,
  });

  @override
  State<_PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<_PreviewImage> {
  FileImage? _cachedImage;

  @override
  void didUpdateWidget(_PreviewImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update cache if image path changed
    if (widget.savedImagePath != oldWidget.savedImagePath) {
      _cachedImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ Use saved image if available
    if (widget.savedImagePath != null && widget.savedImagePath!.isNotEmpty) {
      return FutureBuilder<bool>(
        future: _checkIfFileExists(widget.savedImagePath!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF795548)),
              ),
            );
          }

          if (snapshot.data == true) {
            // Cache the image to prevent reloading
            _cachedImage ??= FileImage(File(widget.savedImagePath!));
            
            return Image(
              image: _cachedImage!, // Use cached image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildReconstructedPreview();
              },
            );
          }

          return _buildReconstructedPreview();
        },
      );
    }

    return _buildReconstructedPreview();
  }

  Widget _buildReconstructedPreview() {
    // Calculate scale factor to fit items in preview
    final scaleX = widget.constraints.maxWidth / widget.canvasWidth;
    final scaleY = widget.constraints.maxHeight / widget.canvasHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    return Container(
      color: Colors.white,
      child: Stack(
        children: widget.placedItems.map((placedItem) {
          // Scale positions and sizes from original canvas
          final scaledLeft = placedItem.position.dx * scale;
          final scaledTop = placedItem.position.dy * scale;
          final scaledWidth = placedItem.width * placedItem.scale * scale;
          final scaledHeight = placedItem.height * placedItem.scale * scale;

          return Positioned(
            left: scaledLeft,
            top: scaledTop,
            child: SizedBox(
              width: scaledWidth,
              height: scaledHeight,
              child: Container(
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
            ),
          );
        }).toList(),
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
                child: CircularProgressIndicator(color: Color(0xFF795548)),
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