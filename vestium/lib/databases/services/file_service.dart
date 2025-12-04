import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<String> saveImageToAppDirectory(String sourcePath) async {
    try {
      // Get the application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      
      // Create a 'vestium_images' subdirectory if it doesn't exist
      final imagesDir = Directory(p.join(appDir.path, 'vestium_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      // Generate a unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = p.extension(sourcePath); // .jpg, .png, etc.
      final filename = 'item_$timestamp$extension';
      final newPath = p.join(imagesDir.path, filename);
      
      // Copy the file from temp location to persistent location
      final sourceFile = File(sourcePath);
      await sourceFile.copy(newPath);
      
      print('✅ Image saved to persistent storage: $newPath');
      return newPath;
    } catch (e) {
      print('❌ Error saving image: $e');
      rethrow;
    }
  }

  static Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print('✅ Image deleted: $imagePath');
      }
    } catch (e) {
      print('❌ Error deleting image: $e');
    }
  }

  static Future<bool> imageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
  
  static Future<String> getTemporaryImagePath() async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return p.join(tempDir.path, 'temp_$timestamp.jpg');
  }
}
