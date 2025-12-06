import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class OutfitImageService {
  /// Save an outfit image to the app's directory
  /// Returns the path where the image was saved
  static Future<String> saveOutfitImage(String sourcePath, {int? outfitId, int? userId}) async {
    try {
      // Get the application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      
      // Create a 'outfit_images' subdirectory if it doesn't exist
      final outfitsDir = Directory(p.join(appDir.path, 'outfit_images'));
      if (!await outfitsDir.exists()) {
        await outfitsDir.create(recursive: true);
      }
      
      // Generate a unique filename
      final String filename;
      if (outfitId != null) {
        // Use outfitId for the filename
        filename = 'outfit_${outfitId}_image${p.extension(sourcePath)}';
      } else {
        // Generate unique filename with timestamp and user ID if provided
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final userIdPart = userId != null ? '_user$userId' : '';
        filename = 'outfit${userIdPart}_$timestamp${p.extension(sourcePath)}';
      }
      
      final newPath = p.join(outfitsDir.path, filename);
      
      // Copy the file from temp location to persistent location
      final sourceFile = File(sourcePath);
      await sourceFile.copy(newPath);
      
      print('✅ Outfit image saved: $newPath');
      return newPath;
    } catch (e) {
      print('❌ Error saving outfit image: $e');
      rethrow;
    }
  }

  /// Get the path for an outfit's image if it exists
  static Future<String?> getOutfitImagePath(int outfitId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final outfitsDir = Directory(p.join(appDir.path, 'outfit_images'));
      
      if (!await outfitsDir.exists()) {
        return null;
      }
      
      // Look for files with pattern outfit_{outfitId}_image*
      final files = await outfitsDir.list().toList();
      
      for (final file in files) {
        final fileName = p.basename(file.path);
        if (fileName.startsWith('outfit_${outfitId}_image')) {
          return file.path;
        }
      }
      
      return null;
    } catch (e) {
      print('❌ Error getting outfit image path: $e');
      return null;
    }
  }

  /// Get all outfit images for a specific user
  static Future<List<String>> getUserOutfitImages(int userId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final outfitsDir = Directory(p.join(appDir.path, 'outfit_images'));
      
      if (!await outfitsDir.exists()) {
        return [];
      }
      
      final files = await outfitsDir.list().toList();
      final userOutfitImages = <String>[];
      
      for (final file in files) {
        final fileName = p.basename(file.path);
        // Check if file belongs to user (contains _user{userId} or we need to check outfitId)
        if (fileName.contains('_user$userId') || 
            await _isOutfitOwnedByUser(file.path, userId)) {
          userOutfitImages.add(file.path);
        }
      }
      
      return userOutfitImages;
    } catch (e) {
      print('❌ Error getting user outfit images: $e');
      return [];
    }
  }

  /// Helper method to check if an outfit belongs to a user
  /// This would require checking your database
  static Future<bool> _isOutfitOwnedByUser(String imagePath, int userId) async {
    // Extract outfitId from filename
    final fileName = p.basename(imagePath);
    final match = RegExp(r'outfit_(\d+)_image').firstMatch(fileName);
    
    if (match != null) {
      final outfitId = int.tryParse(match.group(1)!);
      if (outfitId != null) {
        // Here you would typically query your database
        // For now, return true as a placeholder
        // You'll need to implement database check
        return true;
      }
    }
    return false;
  }

  /// Delete an outfit image
  static Future<void> deleteOutfitImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print('✅ Outfit image deleted: $imagePath');
      }
    } catch (e) {
      print('❌ Error deleting outfit image: $e');
    }
  }

  /// Delete an outfit image by outfitId
  static Future<void> deleteOutfitImageById(int outfitId) async {
    try {
      final imagePath = await getOutfitImagePath(outfitId);
      if (imagePath != null) {
        await deleteOutfitImage(imagePath);
      }
    } catch (e) {
      print('❌ Error deleting outfit image by ID: $e');
    }
  }

  /// Update an outfit image - replaces old one if exists
  static Future<String> updateOutfitImage(int outfitId, String newImagePath, {int? userId}) async {
    try {
      // First, delete any existing image for this outfit
      await deleteOutfitImageById(outfitId);
      
      // Save the new image
      return await saveOutfitImage(newImagePath, outfitId: outfitId, userId: userId);
    } catch (e) {
      print('❌ Error updating outfit image: $e');
      rethrow;
    }
  }

  /// Check if an outfit image exists
  static Future<bool> outfitImageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get temporary path for outfit image editing
  static Future<String> getTemporaryOutfitImagePath() async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return p.join(tempDir.path, 'outfit_temp_$timestamp.jpg');
  }

  /// Get all outfit images (for debugging/cleanup)
  static Future<List<String>> getAllOutfitImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final outfitsDir = Directory(p.join(appDir.path, 'outfit_images'));
      
      if (!await outfitsDir.exists()) {
        return [];
      }
      
      final files = await outfitsDir.list().toList();
      return files.map((file) => file.path).toList();
    } catch (e) {
      print('❌ Error getting all outfit images: $e');
      return [];
    }
  }

  /// Clean up old temporary outfit images
  static Future<void> cleanupOldOutfitImages({int daysOld = 7}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      
      final files = await tempDir.list().toList();
      
      for (final file in files) {
        final fileName = p.basename(file.path);
        if (fileName.startsWith('outfit_temp_')) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await file.delete();
            print('🧹 Cleaned up old temp outfit image: ${file.path}');
          }
        }
      }
    } catch (e) {
      print('❌ Error cleaning up old outfit images: $e');
    }
  }

  /// Copy an outfit image (useful for creating new outfits based on existing ones)
  static Future<String> copyOutfitImage(int sourceOutfitId, int newOutfitId) async {
    try {
      final sourcePath = await getOutfitImagePath(sourceOutfitId);
      if (sourcePath == null) {
        throw Exception('Source outfit image not found');
      }
      
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('Source image file not found');
      }
      
      // Read the source file
      final bytes = await sourceFile.readAsBytes();
      
      // Get directory for new image
      final appDir = await getApplicationDocumentsDirectory();
      final outfitsDir = Directory(p.join(appDir.path, 'outfit_images'));
      if (!await outfitsDir.exists()) {
        await outfitsDir.create(recursive: true);
      }
      
      // Create new filename
      final extension = p.extension(sourcePath);
      final newFilename = 'outfit_${newOutfitId}_image$extension';
      final newPath = p.join(outfitsDir.path, newFilename);
      
      // Write the copied image
      await File(newPath).writeAsBytes(bytes);
      
      print('✅ Outfit image copied from $sourceOutfitId to $newOutfitId');
      return newPath;
    } catch (e) {
      print('❌ Error copying outfit image: $e');
      rethrow;
    }
  }
}