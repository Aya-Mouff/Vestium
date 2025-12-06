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
      
//       // Create a background matching the app theme
//       final backgroundPaint = Paint()
//         ..color = const Color(0xFFF5ECE7)  // Your app background color
//         ..style = PaintingStyle.fill;
//       canvas.drawRect(Rect.fromLTRB(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble()), backgroundPaint);
      
//       // Add a subtle grid or border for visual appeal
//       final borderPaint = Paint()
//         ..color = const Color(0xFFD7CCC8).withValues(alpha: .3)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2;
//       canvas.drawRect(
//         Rect.fromLTRB(20, 20, canvasWidth.toDouble() - 20, canvasHeight.toDouble() - 20),
//         borderPaint,
//       );
      
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
          
//           // Draw a card-like background for each item
//           final cardPaint = Paint()
//             ..color = Colors.white
//             ..style = PaintingStyle.fill;
//           final shadowPaint = Paint()
//             ..color = Colors.black.withValues(alpha: .1)
//             ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
          
//           // Draw shadow
//           canvas.drawRRect(
//             RRect.fromRectAndRadius(
//               Rect.fromLTRB(itemX - 5, itemY - 5, itemX + 105, itemY + 125),
//               const Radius.circular(12),
//             ),
//             shadowPaint,
//           );
          
//           // Draw card background
//           canvas.drawRRect(
//             RRect.fromRectAndRadius(
//               Rect.fromLTRB(itemX, itemY, itemX + 100, itemY + 120),
//               const Radius.circular(12),
//             ),
//             cardPaint,
//           );
          
//           // Draw the image on the card
//           canvas.drawImageRect(
//             image,
//             Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
//             Rect.fromLTRB(
//               itemX + 10,    // Padding inside card
//               itemY + 10,
//               itemX + 90,    // 100 - 10 - 10 padding
//               itemY + 110,   // 120 - 10 - 10 padding
//             ),
//             Paint(),
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
      
//       // Convert the canvas to an image
//       final picture = recorder.endRecording();
//       final compositeImage = await picture.toImage(canvasWidth, canvasHeight);
//       final byteData = await compositeImage.toByteData(format: ui.ImageByteFormat.png);
      
//       if (byteData == null) {
//         print('❌ Failed to convert composite image to byte data');
//         return null;
//       }
      
//       final buffer = byteData.buffer.asUint8List();
      
//       // Save to temporary file
//       final tempDir = await getTemporaryDirectory();
//       final tempPath = p.join(
//         tempDir.path, 
//         'outfit_composite_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png'
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
      
//       // Background
//       final backgroundPaint = Paint()
//         ..color = const Color(0xFFF5ECE7)
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

          
//           // Draw item
//           canvas.drawImageRect(
//             image,
//             Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
//             Rect.fromLTRB(x, y, x + 180, y + 180), // Slightly smaller than card
//             Paint(),
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
      
//       // Convert and save
//       final picture = recorder.endRecording();
//       final compositeImage = await picture.toImage(canvasWidth, canvasHeight);
//       final byteData = await compositeImage.toByteData(format: ui.ImageByteFormat.png);
      
//       if (byteData == null) return null;
      
//       final buffer = byteData.buffer.asUint8List();
//       final tempDir = await getTemporaryDirectory();
//       final tempPath = p.join(
//         tempDir.path, 
//         'outfit_grid_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png'
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
// }

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';
import 'package:vestium/databases/services/file_service.dart';
import 'package:vestium/databases/services/outfit_image_service.dart';

class OutfitCompositeImageService {
  /// Create a composite image from multiple items arranged in the outfit
  /// Items are drawn with full transparency (no backgrounds)
  static Future<String?> createCompositeImage({
    required List<PlacedItemModel> placedItems,
    required int outfitId,
    required int userId,
    int canvasWidth = 800,
    int canvasHeight = 1000,
  }) async {
    try {
      if (placedItems.isEmpty) {
        print('⚠️ No items to create composite image');
        return null;
      }

      print('🎨 Creating composite image for outfit $outfitId with ${placedItems.length} items');

      // If only one item, just use its image directly
      if (placedItems.length == 1) {
        final item = placedItems.first;
        if (item.item.imagePath != null && item.item.imagePath!.isNotEmpty) {
          print('📸 Single item, using its image directly');
          // First ensure it's in the app directory
          final processedPath = await FileService.saveImageToAppDirectory(
            item.item.imagePath!
          );
          // Then save as outfit image
          return await OutfitImageService.saveOutfitImage(
            processedPath,
            outfitId: outfitId,
            userId: userId,
          );
        }
        return null;
      }

      // For multiple items, create a composite
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Create a COMPLETELY TRANSPARENT background
      final backgroundPaint = Paint()
        ..color = Colors.transparent  // ← FULL TRANSPARENCY
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTRB(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble()), backgroundPaint);
      
      // Draw each item at its positioned location (scaled for the composite)
      int drawnItems = 0;
      for (final placedItem in placedItems) {
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
          
          // Scale positions from the create outfit canvas to composite canvas
          // Assuming original canvas was roughly 400x600, scale accordingly
          double scaleX = canvasWidth / 400;
          double scaleY = canvasHeight / 600;
          
          double itemX = placedItem.position.dx * scaleX;
          double itemY = placedItem.position.dy * scaleY;
          
          // Ensure item stays within canvas bounds
          itemX = itemX.clamp(40.0, canvasWidth.toDouble() - 140);
          itemY = itemY.clamp(40.0, canvasHeight.toDouble() - 160);
          
          // =============== REMOVED: White card backgrounds and shadows ===============
          // NO BACKGROUND, NO SHADOWS, NO CARDS - JUST THE IMAGE
          
          // Draw the image DIRECTLY with its natural transparency
          canvas.drawImageRect(
            image,
            Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
            Rect.fromLTRB(
              itemX,    // NO padding - draw at exact position
              itemY,
              itemX + 100,  // Original item size
              itemY + 120,
            ),
            Paint(),  // Default paint preserves transparency
          );
          
          drawnItems++;
          print('✅ Drawn item $drawnItems/${placedItems.length} at position ($itemX, $itemY)');
          
        } catch (e) {
          print('⚠️ Error drawing item ${placedItem.itemId}: $e');
        }
      }
      
      if (drawnItems == 0) {
        print('❌ No items could be drawn for composite');
        return null;
      }
      
      // Convert the canvas to an image (PNG preserves transparency)
      final picture = recorder.endRecording();
      final compositeImage = await picture.toImage(canvasWidth, canvasHeight);
      final byteData = await compositeImage.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        print('❌ Failed to convert composite image to byte data');
        return null;
      }
      
      final buffer = byteData.buffer.asUint8List();
      
      // Save to temporary file as PNG (preserves transparency)
      final tempDir = await getTemporaryDirectory();
      final tempPath = p.join(
        tempDir.path, 
        'outfit_composite_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png'  // .png not .jpg
      );
      
      await File(tempPath).writeAsBytes(buffer);
      print('📁 Composite image saved to temp: $tempPath');
      
      // Verify the file was created
      final tempFile = File(tempPath);
      if (!await tempFile.exists()) {
        print('❌ Temp file was not created');
        return null;
      }
      
      // Save to persistent storage using FileService
      final persistentPath = await FileService.saveImageToAppDirectory(tempPath);
      
      // Clean up temp file
      try {
        await tempFile.delete();
        print('🧹 Deleted temp file');
      } catch (e) {
        print('⚠️ Could not delete temp file: $e');
      }
      
      // Finally, use OutfitImageService to save as an outfit image
      final outfitImagePath = await OutfitImageService.saveOutfitImage(
        persistentPath,
        outfitId: outfitId,
        userId: userId,
      );
      
      print('✅ Composite outfit image saved to: $outfitImagePath');
      return outfitImagePath;
      
    } catch (e) {
      print('❌ Error creating composite image: $e');
      rethrow;
    }
  }
  
  /// Create a simpler composite (grid layout) if positioning fails
  /// Also with full transparency
  static Future<String?> createGridCompositeImage({
    required List<PlacedItemModel> placedItems,
    required int outfitId,
    required int userId,
  }) async {
    try {
      if (placedItems.isEmpty) return null;
      
      final canvasWidth = 800;
      final canvasHeight = 600;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // TRANSPARENT background
      final backgroundPaint = Paint()
        ..color = Colors.transparent  // ← TRANSPARENT
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTRB(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble()), backgroundPaint);
      
      // Calculate grid layout
      final itemsPerRow = 3;
      final itemWidth = 200;
      final itemHeight = 240;
      final padding = 20;
      
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
          
          // Calculate position in grid
          double x = padding.toDouble() + col * (itemWidth.toDouble() + padding.toDouble());
          double y = padding.toDouble() + row * (itemHeight.toDouble() + padding.toDouble());

          // Draw item DIRECTLY with transparency
          canvas.drawImageRect(
            image,
            Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
            Rect.fromLTRB(x, y, x + 180, y + 180),
            Paint(),  // Preserves transparency
          );
          
          // Move to next position
          col++;
          if (col >= itemsPerRow) {
            col = 0;
            row++;
          }
          
        } catch (e) {
          print('⚠️ Error in grid composite for item: $e');
        }
      }
      
      // Convert and save as PNG (preserves transparency)
      final picture = recorder.endRecording();
      final compositeImage = await picture.toImage(canvasWidth, canvasHeight);
      final byteData = await compositeImage.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return null;
      
      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempPath = p.join(
        tempDir.path, 
        'outfit_grid_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png'  // .png
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
  
  /// Helper method to check if an image has transparency
  static Future<bool> hasTransparency(ui.Image image) async {
    try {
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return false;
      
      // Check alpha channel in first few pixels
      final buffer = byteData.buffer.asUint8List();
      for (int i = 3; i < buffer.length && i < 100; i += 4) {
        if (buffer[i] < 255) return true; // Alpha less than 255 means transparency
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}