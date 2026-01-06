// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';
// import 'package:vestium/databases/services/file_service.dart';
// import 'package:vestium/databases/services/outfit_image_service.dart';

// class OutfitCompositeImageService {
//   /// Create a composite image from multiple items arranged in the outfit
//   /// Items are drawn with full transparency (no backgrounds)
//   static Future<String?> createCompositeImage({
//     required List<PlacedItemModel> placedItems,
//     required int outfitId,
//     required int userId,
//     int canvasWidth = 800,
//     int canvasHeight = 1000,
//   }) async {
//     try {
//       if (placedItems.isEmpty) {
//         print('⚠️ No items to create composite image');
//         return null;
//       }

//       print('🎨 Creating composite image for outfit $outfitId with ${placedItems.length} items');

//       // If only one item, just use its image directly
//       if (placedItems.length == 1) {
//         final item = placedItems.first;
//         if (item.item.imagePath != null && item.item.imagePath!.isNotEmpty) {
//           print('📸 Single item, using its image directly');
//           // First ensure it's in the app directory
//           final processedPath = await FileService.saveImageToAppDirectory(
//             item.item.imagePath!
//           );
//           // Then save as outfit image
//           return await OutfitImageService.saveOutfitImage(
//             processedPath,
//             outfitId: outfitId,
//             userId: userId,
//           );
//         }
//         return null;
//       }

//       // For multiple items, create a composite
//       final recorder = ui.PictureRecorder();
//       final canvas = Canvas(recorder);
      
//       // Create a COMPLETELY TRANSPARENT background
//       final backgroundPaint = Paint()
//         ..color = Colors.transparent  // ← FULL TRANSPARENCY
//         ..style = PaintingStyle.fill;
//       canvas.drawRect(Rect.fromLTRB(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble()), backgroundPaint);
      
//       // Draw each item at its positioned location (scaled for the composite)
//       int drawnItems = 0;
//       for (final placedItem in placedItems) {
//         try {
//           final imagePath = placedItem.item.imagePath;
//           if (imagePath == null || imagePath.isEmpty) {
//             print('⚠️ Item ${placedItem.itemId} has no image path, skipping');
//             continue;
//           }
          
//           final imageFile = File(imagePath);
//           if (!await imageFile.exists()) {
//             print('⚠️ Image file not found: $imagePath');
//             continue;
//           }
          
//           final bytes = await imageFile.readAsBytes();
//           final codec = await ui.instantiateImageCodec(bytes);
//           final frame = await codec.getNextFrame();
//           final image = frame.image;
          
//           // Scale positions from the create outfit canvas to composite canvas
//           // Assuming original canvas was roughly 400x600, scale accordingly
//           double scaleX = canvasWidth / 400;
//           double scaleY = canvasHeight / 600;
          
//           double itemX = placedItem.position.dx * scaleX;
//           double itemY = placedItem.position.dy * scaleY;
          
//           // Ensure item stays within canvas bounds
//           itemX = itemX.clamp(40.0, canvasWidth.toDouble() - 140);
//           itemY = itemY.clamp(40.0, canvasHeight.toDouble() - 160);
          
//           // =============== REMOVED: White card backgrounds and shadows ===============
//           // NO BACKGROUND, NO SHADOWS, NO CARDS - JUST THE IMAGE
          
//           // Draw the image DIRECTLY with its natural transparency
//           canvas.drawImageRect(
//             image,
//             Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
//             Rect.fromLTRB(
//               itemX,    // NO padding - draw at exact position
//               itemY,
//               itemX + 100,  // Original item size
//               itemY + 120,
//             ),
//             Paint(),  // Default paint preserves transparency
//           );
          
//           drawnItems++;
//           print('✅ Drawn item $drawnItems/${placedItems.length} at position ($itemX, $itemY)');
          
//         } catch (e) {
//           print('⚠️ Error drawing item ${placedItem.itemId}: $e');
//         }
//       }
      
//       if (drawnItems == 0) {
//         print('❌ No items could be drawn for composite');
//         return null;
//       }
      
//       // Convert the canvas to an image (PNG preserves transparency)
//       final picture = recorder.endRecording();
//       final compositeImage = await picture.toImage(canvasWidth, canvasHeight);
//       final byteData = await compositeImage.toByteData(format: ui.ImageByteFormat.png);
      
//       if (byteData == null) {
//         print('❌ Failed to convert composite image to byte data');
//         return null;
//       }
      
//       final buffer = byteData.buffer.asUint8List();
      
//       // Save to temporary file as PNG (preserves transparency)
//       final tempDir = await getTemporaryDirectory();
//       final tempPath = p.join(
//         tempDir.path, 
//         'outfit_composite_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png'  // .png not .jpg
//       );
      
//       await File(tempPath).writeAsBytes(buffer);
//       print('📁 Composite image saved to temp: $tempPath');
      
//       // Verify the file was created
//       final tempFile = File(tempPath);
//       if (!await tempFile.exists()) {
//         print('❌ Temp file was not created');
//         return null;
//       }
      
//       // Save to persistent storage using FileService
//       final persistentPath = await FileService.saveImageToAppDirectory(tempPath);
      
//       // Clean up temp file
//       try {
//         await tempFile.delete();
//         print('🧹 Deleted temp file');
//       } catch (e) {
//         print('⚠️ Could not delete temp file: $e');
//       }
      
//       // Finally, use OutfitImageService to save as an outfit image
//       final outfitImagePath = await OutfitImageService.saveOutfitImage(
//         persistentPath,
//         outfitId: outfitId,
//         userId: userId,
//       );
      
//       print('✅ Composite outfit image saved to: $outfitImagePath');
//       return outfitImagePath;
      
//     } catch (e) {
//       print('❌ Error creating composite image: $e');
//       rethrow;
//     }
//   }
  
//   /// Create a simpler composite (grid layout) if positioning fails
//   /// Also with full transparency
//   static Future<String?> createGridCompositeImage({
//     required List<PlacedItemModel> placedItems,
//     required int outfitId,
//     required int userId,
//   }) async {
//     try {
//       if (placedItems.isEmpty) return null;
      
//       final canvasWidth = 800;
//       final canvasHeight = 600;
//       final recorder = ui.PictureRecorder();
//       final canvas = Canvas(recorder);
      
//       // TRANSPARENT background
//       final backgroundPaint = Paint()
//         ..color = Colors.transparent  // ← TRANSPARENT
//         ..style = PaintingStyle.fill;
//       canvas.drawRect(Rect.fromLTRB(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble()), backgroundPaint);
      
//       // Calculate grid layout
//       final itemsPerRow = 3;
//       final itemWidth = 200;
//       final itemHeight = 240;
//       final padding = 20;
      
//       int row = 0;
//       int col = 0;
      
//       for (final placedItem in placedItems) {
//         try {
//           final imagePath = placedItem.item.imagePath;
//           if (imagePath == null || imagePath.isEmpty) continue;
          
//           final imageFile = File(imagePath);
//           if (!await imageFile.exists()) continue;
          
//           final bytes = await imageFile.readAsBytes();
//           final codec = await ui.instantiateImageCodec(bytes);
//           final frame = await codec.getNextFrame();
//           final image = frame.image;
          
//           // Calculate position in grid
//           double x = padding.toDouble() + col * (itemWidth.toDouble() + padding.toDouble());
//           double y = padding.toDouble() + row * (itemHeight.toDouble() + padding.toDouble());

//           // Draw item DIRECTLY with transparency
//           canvas.drawImageRect(
//             image,
//             Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
//             Rect.fromLTRB(x, y, x + 180, y + 180),
//             Paint(),  // Preserves transparency
//           );
          
//           // Move to next position
//           col++;
//           if (col >= itemsPerRow) {
//             col = 0;
//             row++;
//           }
          
//         } catch (e) {
//           print('⚠️ Error in grid composite for item: $e');
//         }
//       }
      
//       // Convert and save as PNG (preserves transparency)
//       final picture = recorder.endRecording();
//       final compositeImage = await picture.toImage(canvasWidth, canvasHeight);
//       final byteData = await compositeImage.toByteData(format: ui.ImageByteFormat.png);
      
//       if (byteData == null) return null;
      
//       final buffer = byteData.buffer.asUint8List();
//       final tempDir = await getTemporaryDirectory();
//       final tempPath = p.join(
//         tempDir.path, 
//         'outfit_grid_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png'  // .png
//       );
      
//       await File(tempPath).writeAsBytes(buffer);
//       final persistentPath = await FileService.saveImageToAppDirectory(tempPath);
//       await File(tempPath).delete();
      
//       return await OutfitImageService.saveOutfitImage(
//         persistentPath,
//         outfitId: outfitId,
//         userId: userId,
//       );
      
//     } catch (e) {
//       print('❌ Error creating grid composite: $e');
//       return null;
//     }
//   }
  
//   /// Helper method to check if an image has transparency
//   static Future<bool> hasTransparency(ui.Image image) async {
//     try {
//       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       if (byteData == null) return false;
      
//       // Check alpha channel in first few pixels
//       final buffer = byteData.buffer.asUint8List();
//       for (int i = 3; i < buffer.length && i < 100; i += 4) {
//         if (buffer[i] < 255) return true; // Alpha less than 255 means transparency
//       }
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }
// }

// =====================================================================

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';
import 'package:vestium/databases/services/file_service.dart';
import 'package:vestium/databases/services/outfit_image_service.dart';

class OutfitCompositeImageService {
  /// Create a composite image with ONLY the outfit items (no canvas)
  /// Tightly cropped with small padding around the edges
  /// Uses DOUBLE PRECISION to avoid rounding gaps between items
  static Future<String?> createCompositeImage({
    required List<PlacedItemModel> placedItems,
    required int outfitId,
    required int userId,
    double padding = 20.0, // Small padding around outfit
    int scaleFactor = 2, // Render at 2x resolution to preserve precision
  }) async {
    try {
      if (placedItems.isEmpty) {
        print('⚠️ No items to create composite image');
        return null;
      }

      print('🎨 Creating HIGH PRECISION outfit image for outfit $outfitId with ${placedItems.length} items');

      // If only one item, use its image directly
      if (placedItems.length == 1) {
        final item = placedItems.first;
        if (item.item.imagePath != null && item.item.imagePath!.isNotEmpty) {
          print('📸 Single item, using its image directly');
          final processedPath = await FileService.saveImageToAppDirectory(
            item.item.imagePath!
          );
          return await OutfitImageService.saveOutfitImage(
            processedPath,
            outfitId: outfitId,
            userId: userId,
          );
        }
        return null;
      }

      // === STEP 1: Find tight bounding box with DOUBLE PRECISION ===
      double minX = double.infinity;
      double minY = double.infinity;
      double maxX = double.negativeInfinity;
      double maxY = double.negativeInfinity;

      for (final item in placedItems) {
        // Use EXACT double precision (no rounding yet)
        final itemWidth = 100.0 * item.scale;
        final itemHeight = 120.0 * item.scale;
        
        final left = item.position.dx;
        final top = item.position.dy;
        final right = item.position.dx + itemWidth;
        final bottom = item.position.dy + itemHeight;
        
        if (left < minX) minX = left;
        if (top < minY) minY = top;
        if (right > maxX) maxX = right;
        if (bottom > maxY) maxY = bottom;
      }

      print('📐 Outfit bounds (PRECISE): X($minX → $maxX), Y($minY → $maxY)');

      // === STEP 2: Calculate final image size with SCALE FACTOR for precision ===
      final outfitWidth = maxX - minX;
      final outfitHeight = maxY - minY;
      
      // Render at higher resolution to preserve sub-pixel positioning
      final finalWidth = ((outfitWidth + padding * 2) * scaleFactor).round();
      final finalHeight = ((outfitHeight + padding * 2) * scaleFactor).round();

      print('📐 Final image size: ${finalWidth}x$finalHeight at ${scaleFactor}x (base: ${(outfitWidth + padding * 2).toInt()}x${(outfitHeight + padding * 2).toInt()})');

      // === STEP 3: Create canvas and draw items with SUB-PIXEL PRECISION ===
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Transparent background
      final backgroundPaint = Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTRB(0, 0, finalWidth.toDouble(), finalHeight.toDouble()), 
        backgroundPaint
      );

      // Sort items by z-index (render in correct order)
      final sortedItems = List<PlacedItemModel>.from(placedItems);
      sortedItems.sort((a, b) => a.zIndex.compareTo(b.zIndex));
      
      // Draw each item with EXACT DOUBLE PRECISION (no rounding until final step)
      int drawnItems = 0;
      for (final placedItem in sortedItems) {
        try {
          final imagePath = placedItem.item.imagePath;
          if (imagePath == null || imagePath.isEmpty) {
            print('⚠️ Item ${placedItem.itemId} has no image path, skipping');
            continue;
          }
          
          final imageFile = File(imagePath);
          if (!await imageFile.exists()) {
            print('⚠️ Image file not found: $imagePath');
            continue;
          }
          
          final bytes = await imageFile.readAsBytes();
          final codec = await ui.instantiateImageCodec(bytes);
          final frame = await codec.getNextFrame();
          final image = frame.image;
          
          // Calculate position with DOUBLE PRECISION (scaled by scaleFactor)
          final relativeX = ((placedItem.position.dx - minX) + padding) * scaleFactor;
          final relativeY = ((placedItem.position.dy - minY) + padding) * scaleFactor;
          
          // Calculate size with DOUBLE PRECISION (scaled by scaleFactor)
          final itemWidth = 100.0 * placedItem.scale * scaleFactor;
          final itemHeight = 120.0 * placedItem.scale * scaleFactor;
          
          // Draw with EXACT double coordinates (Flutter Canvas preserves sub-pixel precision)
          canvas.drawImageRect(
            image,
            Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
            Rect.fromLTRB(
              relativeX,
              relativeY,
              relativeX + itemWidth,
              relativeY + itemHeight,
            ),
            Paint()
              ..filterQuality = FilterQuality.high
              ..isAntiAlias = true, // Smooth edges at sub-pixel positions
          );
          
          drawnItems++;
          print('✅ Item $drawnItems/${placedItems.length}: pos($relativeX, $relativeY) size($itemWidth x $itemHeight) scale(${placedItem.scale}) z(${placedItem.zIndex})');
          
        } catch (e) {
          print('⚠️ Error drawing item ${placedItem.itemId}: $e');
        }
      }
      
      if (drawnItems == 0) {
        print('❌ No items could be drawn for composite');
        return null;
      }
      
      // === STEP 4: Convert to PNG and save ===
      final picture = recorder.endRecording();
      final compositeImage = await picture.toImage(finalWidth, finalHeight);
      final byteData = await compositeImage.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        print('❌ Failed to convert composite image to byte data');
        return null;
      }
      
      final buffer = byteData.buffer.asUint8List();
      
      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempPath = p.join(
        tempDir.path, 
        'outfit_composite_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png'
      );
      
      await File(tempPath).writeAsBytes(buffer);
      print('💾 Composite saved to temp: $tempPath (${(buffer.length / 1024).toStringAsFixed(1)} KB)');
      
      // Verify file
      final tempFile = File(tempPath);
      if (!await tempFile.exists()) {
        print('❌ Temp file was not created');
        return null;
      }
      
      // Save to persistent storage
      final persistentPath = await FileService.saveImageToAppDirectory(tempPath);
      
      // Clean up temp file
      try {
        await tempFile.delete();
        print('🧹 Deleted temp file');
      } catch (e) {
        print('⚠️ Could not delete temp file: $e');
      }
      
      // Save as outfit image
      final outfitImagePath = await OutfitImageService.saveOutfitImage(
        persistentPath,
        outfitId: outfitId,
        userId: userId,
      );
      
      print('✅ Tightly cropped outfit image saved: $outfitImagePath');
      return outfitImagePath;
      
    } catch (e) {
      print('❌ Error creating composite image: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }
  
  /// Create a grid composite as fallback (also tightly cropped)
  static Future<String?> createGridCompositeImage({
    required List<PlacedItemModel> placedItems,
    required int outfitId,
    required int userId,
  }) async {
    try {
      if (placedItems.isEmpty) return null;
      
      // Calculate grid dimensions
      final itemsPerRow = 3;
      final itemWidth = 200;
      final itemHeight = 240;
      final padding = 20;
      
      final rows = (placedItems.length / itemsPerRow).ceil();
      final cols = placedItems.length < itemsPerRow ? placedItems.length : itemsPerRow;
      
      final canvasWidth = (cols * itemWidth) + ((cols + 1) * padding);
      final canvasHeight = (rows * itemHeight) + ((rows + 1) * padding);
      
      print('📐 Grid: ${cols}x$rows, Canvas: ${canvasWidth}x$canvasHeight');
      
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Transparent background
      final backgroundPaint = Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTRB(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble()), 
        backgroundPaint
      );
      
      int row = 0;
      int col = 0;
      
      for (final placedItem in placedItems) {
        try {
          final imagePath = placedItem.item.imagePath;
          if (imagePath == null || imagePath.isEmpty) continue;
          
          final imageFile = File(imagePath);
          if (!await imageFile.exists()) continue;
          
          final bytes = await imageFile.readAsBytes();
          final codec = await ui.instantiateImageCodec(bytes);
          final frame = await codec.getNextFrame();
          final image = frame.image;
          
          double x = padding.toDouble() + col * (itemWidth.toDouble() + padding.toDouble());
          double y = padding.toDouble() + row * (itemHeight.toDouble() + padding.toDouble());

          canvas.drawImageRect(
            image,
            Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
            Rect.fromLTRB(x, y, x + 180, y + 180),
            Paint()..filterQuality = FilterQuality.high,
          );
          
          col++;
          if (col >= itemsPerRow) {
            col = 0;
            row++;
          }
          
        } catch (e) {
          print('⚠️ Error in grid composite for item: $e');
        }
      }
      
      final picture = recorder.endRecording();
      final compositeImage = await picture.toImage(canvasWidth, canvasHeight);
      final byteData = await compositeImage.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return null;
      
      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempPath = p.join(
        tempDir.path, 
        'outfit_grid_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png'
      );
      
      await File(tempPath).writeAsBytes(buffer);
      final persistentPath = await FileService.saveImageToAppDirectory(tempPath);
      await File(tempPath).delete();
      
      return await OutfitImageService.saveOutfitImage(
        persistentPath,
        outfitId: outfitId,
        userId: userId,
      );
      
    } catch (e) {
      print('❌ Error creating grid composite: $e');
      return null;
    }
  }
}