import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class UserProfileService {
  /// Save a user profile picture to the app's directory
  /// Returns the path where the image was saved
  static Future<String> saveUserProfileImage(String sourcePath, {int? userId}) async {
    try {
      // Get the application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      
      // Create a 'user_profiles' subdirectory if it doesn't exist
      final profilesDir = Directory(p.join(appDir.path, 'user_profiles'));
      if (!await profilesDir.exists()) {
        await profilesDir.create(recursive: true);
      }
      
      // Generate filename: either with userId or timestamp
      final String filename;
      if (userId != null) {
        // Use userId for the filename to make it easily retrievable
        filename = 'user_${userId}_profile${p.extension(sourcePath)}';
      } else {
        // Fallback to timestamp if userId is not available
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        filename = 'user_profile_$timestamp${p.extension(sourcePath)}';
      }
      
      final newPath = p.join(profilesDir.path, filename);
      
      // Copy the file from temp location to persistent location
      final sourceFile = File(sourcePath);
      await sourceFile.copy(newPath);
      
      print('✅ User profile image saved: $newPath');
      return newPath;
    } catch (e) {
      print('❌ Error saving user profile image: $e');
      rethrow;
    }
  }

  /// Delete a user's profile image
  static Future<void> deleteUserProfileImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print('✅ User profile image deleted: $imagePath');
      }
    } catch (e) {
      print('❌ Error deleting user profile image: $e');
    }
  }

  /// Check if a user profile image exists
  static Future<bool> userProfileImageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get the path for a user's profile image if it exists
  /// Returns null if no profile image found for the user
  static Future<String?> getUserProfileImagePath(int userId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profilesDir = Directory(p.join(appDir.path, 'user_profiles'));
      
      if (!await profilesDir.exists()) {
        return null;
      }
      
      // Look for files with pattern user_{userId}_profile*
      final files = await profilesDir.list().toList();
      
      for (final file in files) {
        final fileName = p.basename(file.path);
        if (fileName.startsWith('user_${userId}_profile')) {
          return file.path;
        }
      }
      
      return null;
    } catch (e) {
      print('❌ Error getting user profile image path: $e');
      return null;
    }
  }

  /// Get temporary path for profile image editing
  static Future<String> getTemporaryProfileImagePath() async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return p.join(tempDir.path, 'profile_temp_$timestamp.jpg');
  }

  /// Update user profile image - replaces old one if exists
  static Future<String> updateUserProfileImage(int userId, String newImagePath) async {
    try {
      // First, delete any existing profile image for this user
      final existingPath = await getUserProfileImagePath(userId);
      if (existingPath != null) {
        await deleteUserProfileImage(existingPath);
      }
      
      // Save the new image
      return await saveUserProfileImage(newImagePath, userId: userId);
    } catch (e) {
      print('❌ Error updating user profile image: $e');
      rethrow;
    }
  }

  /// Get all user profile images (for debugging/cleanup)
  static Future<List<String>> getAllUserProfileImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profilesDir = Directory(p.join(appDir.path, 'user_profiles'));
      
      if (!await profilesDir.exists()) {
        return [];
      }
      
      final files = await profilesDir.list().toList();
      return files.map((file) => file.path).toList();
    } catch (e) {
      print('❌ Error getting all user profile images: $e');
      return [];
    }
  }

  /// Clean up old temporary profile images
  static Future<void> cleanupOldProfileImages({int daysOld = 7}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      
      final files = await tempDir.list().toList();
      
      for (final file in files) {
        final fileName = p.basename(file.path);
        if (fileName.startsWith('profile_temp_')) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await file.delete();
            print('🧹 Cleaned up old temp profile image: ${file.path}');
          }
        }
      }
    } catch (e) {
      print('❌ Error cleaning up old profile images: $e');
    }
  }
}