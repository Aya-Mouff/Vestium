import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vestium/databases/services/file_service.dart';
import 'package:vestium/databases/services/outfit_image_service.dart';

/// Screenshot-based outfit capture - captures EXACTLY what's on screen
class OutfitScreenshotService {
  /// Capture the canvas and crop to outfit bounds
  /// 
  /// [canvasKey] - GlobalKey attached to the canvas Stack widget
  /// [outfitId] - ID of the outfit being saved
  /// [userId] - ID of the user
  /// [padding] - Extra space around the cropped outfit (default: 20.0)
  /// [quality] - Image quality multiplier (default: 2.0 for 2x resolution)
  static Future<String?> captureAndCropOutfit({
    required GlobalKey canvasKey,
    required int outfitId,
    required int userId,
    double padding = 20.0,
    double quality = 2.0,
  }) async {
    try {
      print('📸 Starting screenshot capture for outfit $outfitId');

      // === STEP 1: Capture the canvas as an image ===
      final RenderRepaintBoundary boundary = canvasKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // Capture at high quality
      final ui.Image fullImage = await boundary.toImage(
        pixelRatio: quality,
      );

      print('✅ Canvas captured: ${fullImage.width}x${fullImage.height}');

      // === STEP 2: Detect non-transparent bounds ===
      final byteData = await fullImage.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      if (byteData == null) {
        print('❌ Failed to get image byte data');
        return null;
      }

      final buffer = byteData.buffer.asUint8List();
      final width = fullImage.width;
      final height = fullImage.height;

      // Find the bounds of non-transparent pixels
      int minX = width;
      int maxX = 0;
      int minY = height;
      int maxY = 0;

      bool hasContent = false;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final pixelIndex = (y * width + x) * 4;
          final alpha = buffer[pixelIndex + 3];

          // If pixel is not fully transparent
          if (alpha > 10) {
            hasContent = true;
            if (x < minX) minX = x;
            if (x > maxX) maxX = x;
            if (y < minY) minY = y;
            if (y > maxY) maxY = y;
          }
        }
      }

      if (!hasContent) {
        print('⚠️ No visible content found in canvas');
        return null;
      }

      print('📐 Content bounds: X($minX → $maxX), Y($minY → $maxY)');

      // === STEP 3: Add padding and clamp to image bounds ===
      final paddingPx = (padding * quality).toInt();
      
      minX = (minX - paddingPx).clamp(0, width - 1);
      maxX = (maxX + paddingPx).clamp(0, width - 1);
      minY = (minY - paddingPx).clamp(0, height - 1);
      maxY = (maxY + paddingPx).clamp(0, height - 1);

      final cropWidth = maxX - minX + 1;
      final cropHeight = maxY - minY + 1;

      print('✂️ Cropping to: ${cropWidth}x$cropHeight (with padding)');

      // === STEP 4: Crop the image ===
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Draw the cropped section
      canvas.drawImageRect(
        fullImage,
        Rect.fromLTWH(
          minX.toDouble(),
          minY.toDouble(),
          cropWidth.toDouble(),
          cropHeight.toDouble(),
        ),
        Rect.fromLTWH(0, 0, cropWidth.toDouble(), cropHeight.toDouble()),
        Paint()..filterQuality = FilterQuality.high,
      );

      final picture = recorder.endRecording();
      final croppedImage = await picture.toImage(cropWidth, cropHeight);

      // === STEP 5: Convert to PNG and save ===
      final pngByteData = await croppedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (pngByteData == null) {
        print('❌ Failed to convert to PNG');
        return null;
      }

      final pngBuffer = pngByteData.buffer.asUint8List();
      final sizeKB = (pngBuffer.length / 1024).toStringAsFixed(1);

      print('💾 Image size: $sizeKB KB');

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempPath = p.join(
        tempDir.path,
        'outfit_screenshot_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await File(tempPath).writeAsBytes(pngBuffer);
      print('✅ Saved to temp: $tempPath');

      // Move to persistent storage
      final persistentPath = await FileService.saveImageToAppDirectory(tempPath);

      // Cleanup temp file
      try {
        await File(tempPath).delete();
      } catch (e) {
        print('⚠️ Could not delete temp file: $e');
      }

      // Save as outfit image
      final outfitImagePath = await OutfitImageService.saveOutfitImage(
        persistentPath,
        outfitId: outfitId,
        userId: userId,
      );

      print('🎉 Outfit screenshot saved: $outfitImagePath');
      return outfitImagePath;

    } catch (e, stackTrace) {
      print('❌ Error capturing outfit screenshot: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Quick capture without cropping (full canvas)
  static Future<String?> captureFullCanvas({
    required GlobalKey canvasKey,
    required int outfitId,
    required int userId,
    double quality = 2.0,
  }) async {
    try {
      print('📸 Capturing full canvas for outfit $outfitId');

      final RenderRepaintBoundary boundary = canvasKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: quality);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        print('❌ Failed to get image data');
        return null;
      }

      final buffer = byteData.buffer.asUint8List();

      // Save to temp
      final tempDir = await getTemporaryDirectory();
      final tempPath = p.join(
        tempDir.path,
        'outfit_full_${outfitId}_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await File(tempPath).writeAsBytes(buffer);

      // Move to persistent storage
      final persistentPath = await FileService.saveImageToAppDirectory(tempPath);
      await File(tempPath).delete();

      // Save as outfit image
      return await OutfitImageService.saveOutfitImage(
        persistentPath,
        outfitId: outfitId,
        userId: userId,
      );

    } catch (e) {
      print('❌ Error capturing full canvas: $e');
      return null;
    }
  }

  /// Helper: Check if bounds detection is working
  static Future<Map<String, dynamic>> analyzeCanvas(GlobalKey canvasKey) async {
    try {
      final RenderRepaintBoundary boundary = canvasKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

      if (byteData == null) return {'error': 'No byte data'};

      final buffer = byteData.buffer.asUint8List();
      final width = image.width;
      final height = image.height;

      int minX = width, maxX = 0, minY = height, maxY = 0;
      int pixelCount = 0;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final alpha = buffer[(y * width + x) * 4 + 3];
          if (alpha > 10) {
            pixelCount++;
            if (x < minX) minX = x;
            if (x > maxX) maxX = x;
            if (y < minY) minY = y;
            if (y > maxY) maxY = y;
          }
        }
      }

      return {
        'canvasSize': '${width}x$height',
        'contentBounds': 'X($minX → $maxX), Y($minY → $maxY)',
        'contentSize': '${maxX - minX}x${maxY - minY}',
        'pixelsWithContent': pixelCount,
        'percentageFilled': ((pixelCount / (width * height)) * 100).toStringAsFixed(2),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}