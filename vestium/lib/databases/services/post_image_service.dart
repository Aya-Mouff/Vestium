import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PostImageService {
  /// Save a post image to the app's directory
  /// Returns the path where the image was saved
  static Future<String> savePostImage(String sourcePath, {int? postId, int? userId}) async {
    try {
      // Get the application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      
      // Create a 'post_images' subdirectory if it doesn't exist
      final postsDir = Directory(p.join(appDir.path, 'post_images'));
      if (!await postsDir.exists()) {
        await postsDir.create(recursive: true);
      }
      
      // Generate a unique filename
      final String filename;
      if (postId != null) {
        // Use postId for the filename
        filename = 'post_${postId}_image${p.extension(sourcePath)}';
      } else {
        // Generate unique filename with timestamp and user ID if provided
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final userIdPart = userId != null ? '_user$userId' : '';
        filename = 'post${userIdPart}_$timestamp${p.extension(sourcePath)}';
      }
      
      final newPath = p.join(postsDir.path, filename);
      
      // Copy the file from temp location to persistent location
      final sourceFile = File(sourcePath);
      await sourceFile.copy(newPath);
      
      print('✅ Post image saved: $newPath');
      return newPath;
    } catch (e) {
      print('❌ Error saving post image: $e');
      rethrow;
    }
  }

  /// Get the path for a post's image if it exists
  static Future<String?> getPostImagePath(int postId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final postsDir = Directory(p.join(appDir.path, 'post_images'));
      
      if (!await postsDir.exists()) {
        return null;
      }
      
      // Look for files with pattern post_{postId}_image*
      final files = await postsDir.list().toList();
      
      for (final file in files) {
        final fileName = p.basename(file.path);
        if (fileName.startsWith('post_${postId}_image')) {
          return file.path;
        }
      }
      
      return null;
    } catch (e) {
      print('❌ Error getting post image path: $e');
      return null;
    }
  }

  /// Get all post images for a specific user
  static Future<List<String>> getUserPostImages(int userId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final postsDir = Directory(p.join(appDir.path, 'post_images'));
      
      if (!await postsDir.exists()) {
        return [];
      }
      
      final files = await postsDir.list().toList();
      final userPostImages = <String>[];
      
      for (final file in files) {
        final fileName = p.basename(file.path);
        // Check if file belongs to user (contains _user{userId})
        if (fileName.contains('_user$userId')) {
          userPostImages.add(file.path);
        }
      }
      
      return userPostImages;
    } catch (e) {
      print('❌ Error getting user post images: $e');
      return [];
    }
  }

  /// Delete a post image
  static Future<void> deletePostImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print('✅ Post image deleted: $imagePath');
      }
    } catch (e) {
      print('❌ Error deleting post image: $e');
    }
  }

  /// Delete a post image by postId
  static Future<void> deletePostImageById(int postId) async {
    try {
      final imagePath = await getPostImagePath(postId);
      if (imagePath != null) {
        await deletePostImage(imagePath);
      }
    } catch (e) {
      print('❌ Error deleting post image by ID: $e');
    }
  }

  /// Update a post image - replaces old one if exists
  static Future<String> updatePostImage(int postId, String newImagePath, {int? userId}) async {
    try {
      // First, delete any existing image for this post
      await deletePostImageById(postId);
      
      // Save the new image
      return await savePostImage(newImagePath, postId: postId, userId: userId);
    } catch (e) {
      print('❌ Error updating post image: $e');
      rethrow;
    }
  }

  /// Check if a post image exists
  static Future<bool> postImageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get temporary path for post image editing
  static Future<String> getTemporaryPostImagePath() async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return p.join(tempDir.path, 'post_temp_$timestamp.jpg');
  }

  /// Get all post images (for debugging/cleanup)
  static Future<List<String>> getAllPostImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final postsDir = Directory(p.join(appDir.path, 'post_images'));
      
      if (!await postsDir.exists()) {
        return [];
      }
      
      final files = await postsDir.list().toList();
      return files.map((file) => file.path).toList();
    } catch (e) {
      print('❌ Error getting all post images: $e');
      return [];
    }
  }

  /// Clean up old temporary post images
  static Future<void> cleanupOldPostImages({int daysOld = 7}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      
      final files = await tempDir.list().toList();
      
      for (final file in files) {
        final fileName = p.basename(file.path);
        if (fileName.startsWith('post_temp_')) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await file.delete();
            print('🧹 Cleaned up old temp post image: ${file.path}');
          }
        }
      }
    } catch (e) {
      print('❌ Error cleaning up old post images: $e');
    }
  }

  /// Copy a post image (useful for sharing/reposting)
  static Future<String> copyPostImage(int sourcePostId, int newPostId, {int? userId}) async {
    try {
      final sourcePath = await getPostImagePath(sourcePostId);
      if (sourcePath == null) {
        throw Exception('Source post image not found');
      }
      
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('Source image file not found');
      }
      
      // Read the source file
      final bytes = await sourceFile.readAsBytes();
      
      // Get directory for new image
      final appDir = await getApplicationDocumentsDirectory();
      final postsDir = Directory(p.join(appDir.path, 'post_images'));
      if (!await postsDir.exists()) {
        await postsDir.create(recursive: true);
      }
      
      // Create new filename
      final extension = p.extension(sourcePath);
      final newFilename = 'post_${newPostId}_image$extension';
      final newPath = p.join(postsDir.path, newFilename);
      
      // Write the copied image
      await File(newPath).writeAsBytes(bytes);
      
      print('✅ Post image copied from $sourcePostId to $newPostId');
      return newPath;
    } catch (e) {
      print('❌ Error copying post image: $e');
      rethrow;
    }
  }

  /// Get multiple post images by their IDs
  static Future<Map<int, String?>> getMultiplePostImages(List<int> postIds) async {
    final result = <int, String?>{};
    
    for (final postId in postIds) {
      final imagePath = await getPostImagePath(postId);
      result[postId] = imagePath;
    }
    
    return result;
  }

  /// Check if post images directory exists, create if not
  static Future<void> ensurePostImagesDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final postsDir = Directory(p.join(appDir.path, 'post_images'));
      
      if (!await postsDir.exists()) {
        await postsDir.create(recursive: true);
        print('✅ Created post_images directory');
      }
    } catch (e) {
      print('❌ Error ensuring post images directory: $e');
    }
  }

  /// Get total size of all post images (in bytes)
  static Future<int> getTotalPostImagesSize() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final postsDir = Directory(p.join(appDir.path, 'post_images'));
      
      if (!await postsDir.exists()) {
        return 0;
      }
      
      final files = await postsDir.list().toList();
      int totalSize = 0;
      
      for (final file in files) {
        final stat = await file.stat();
        totalSize += stat.size;
      }
      
      return totalSize;
    } catch (e) {
      print('❌ Error calculating post images size: $e');
      return 0;
    }
  }
}