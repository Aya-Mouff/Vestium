// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vestium/data/dummy/dummy-data-loader.dart';
// import 'edit_outfit_state.dart';

// class EditOutfitCubit extends Cubit<EditOutfitState> {
//   EditOutfitCubit({required String outfitId})
//       : super(EditOutfitState(outfitId: outfitId)) {
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       final data = await DummyDataLoader.loadDummyData();
//       final outfits = data['outfits'] as List<dynamic>;
//       final users = data['users'] as List<dynamic>;

//       // Get current user (user with id "1")
//       final user = users.cast<Map<String, dynamic>?>().firstWhere(
//         (u) => u?['id'].toString() == '1',
//         orElse: () => null,
//       );

//       // Find the outfit by ID
//       final foundOutfit = outfits.cast<Map<String, dynamic>?>().firstWhere(
//         (o) => o?['id'].toString() == state.outfitId,
//         orElse: () => null,
//       );

//       if (foundOutfit != null && user != null) {
//         // Get user's custom outfit categories
//         final customCategories = user['customOutfitCategories'] as List<dynamic>?;

//         // Handle season - could be string or array
//         String? selectedSeason;
//         final season = foundOutfit['season'];
//         if (season is String) {
//           selectedSeason = season == 'all' ? 'All Season' : _capitalizeFirstLetter(season);
//         } else if (season is List && season.isNotEmpty) {
//           selectedSeason = _capitalizeFirstLetter(season[0].toString());
//         }

//         emit(state.copyWith(
//           currentUser: user,
//           outfit: foundOutfit,
//           userCategories: customCategories?.cast<String>().toList() ?? state.userCategories,
//           name: foundOutfit['name'] ?? '',
//           description: foundOutfit['description'] ?? '',
//           selectedCategory: foundOutfit['category'],
//           selectedSeason: selectedSeason,
//           isLoading: false,
//         ));
//       } else {
//         emit(state.copyWith(
//           isLoading: false,
//           hasError: true,
//         ));
//       }
//     } catch (e) {
//       print('Error loading data: $e');
//       emit(state.copyWith(
//         isLoading: false,
//         hasError: true,
//       ));
//     }
//   }

//   String _capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1).toLowerCase();
//   }

//   void updateName(String name) {
//     emit(state.copyWith(name: name));
//   }

//   void updateDescription(String description) {
//     emit(state.copyWith(description: description));
//   }

//   void updateCategory(String? category) {
//     emit(state.copyWith(selectedCategory: category));
//   }

//   void updateSeason(String? season) {
//     emit(state.copyWith(selectedSeason: season));
//   }

//   void refresh() {
//     emit(state.copyWith(isLoading: true));
//     _loadData();
//   }
// }

// ==================================================================

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vestium/databases/db_models.dart';
// import 'package:vestium/repo/outfit_repo.dart';
// import 'package:vestium/repo/outfit_item_repo.dart';
// import 'package:vestium/repo/outfit_category_join_repo.dart';
// import 'package:vestium/repo/post_repo.dart';
// import 'package:vestium/repo/item_repo.dart';
// import 'package:vestium/databases/services/outfit_category_service.dart';
// import 'package:vestium/databases/services/current_user_service.dart';
// import 'package:vestium/databases/services/outfit_image_service.dart';
// // import 'package:vestium/databases/services/file_service.dart';
// import 'edit_outfit_state.dart';

// class EditOutfitCubit extends Cubit<EditOutfitState> {
//   final OutfitRepo _outfitRepo = OutfitRepo();
//   final OutfitItemRepo _outfitItemRepo = OutfitItemRepo();
//   final OutfitCategoryJoinRepo _outfitCategoryJoinRepo =
//       OutfitCategoryJoinRepo();
//   final PostRepo _postRepo = PostRepo();
//   final ItemRepo _itemRepo = ItemRepo();
//   final OutfitCategoryService _categoryService = OutfitCategoryService();

//   EditOutfitCubit({required int outfitId})
//     : super(EditOutfitState(outfitId: outfitId.toString())) {
//     _loadOutfitData();
//   }

//   Future<void> _loadOutfitData() async {
//     try {
//       emit(state.copyWith(isLoading: true));

//       print('🔄 Loading outfit data for ID: ${state.outfitId}');

//       // 1. Load current user
//       final currentUser = CurrentUserService.currentUser;
//       if (currentUser == null || currentUser.userId == null) {
//         print('❌ No user logged in');
//         emit(
//           state.copyWith(
//             isLoading: false,
//             hasError: true,
//             errorMessage: 'User not logged in',
//           ),
//         );
//         return;
//       }

//       // 2. Load the outfit
//       final outfitId = int.tryParse(state.outfitId);
//       if (outfitId == null) {
//         print('❌ Invalid outfit ID: ${state.outfitId}');
//         emit(
//           state.copyWith(
//             isLoading: false,
//             hasError: true,
//             errorMessage: 'Invalid outfit ID',
//           ),
//         );
//         return;
//       }

//       final outfit = await _outfitRepo.getById(outfitId);
//       if (outfit == null) {
//         print('❌ Outfit not found in database: $outfitId');
//         emit(
//           state.copyWith(
//             isLoading: false,
//             hasError: true,
//             errorMessage: 'Outfit not found',
//           ),
//         );
//         return;
//       }

//       // 3. Verify the outfit belongs to current user
//       if (outfit.userId != currentUser.userId) {
//         print(
//           '❌ Outfit belongs to user ${outfit.userId}, but current user is ${currentUser.userId}',
//         );
//         emit(
//           state.copyWith(
//             isLoading: false,
//             hasError: true,
//             errorMessage: 'You can only edit your own outfits',
//           ),
//         );
//         return;
//       }

//       // 4. Check if outfit has associated posts
//       final posts = await _postRepo.getByOutfitId(outfitId);
//       final hasPosts = posts.isNotEmpty;

//       // 5. Load outfit image path if exists
//       final imagePath = await OutfitImageService.getOutfitImagePath(outfitId);
//       print('📸 Outfit image path: ${imagePath ?? "No image found"}');

//       // 6. Load all available categories from database
//       await _categoryService.ensureInitialCategories();
//       final allCategories = await _categoryService.getAllCategories();
//       print('🏷️ Loaded ${allCategories.length} categories from database');

//       // 7. Load categories for this outfit
//       final outfitCategories = await _outfitCategoryJoinRepo
//           .getCategoriesForOutfit(outfitId);
//       final selectedCategory = outfitCategories.isNotEmpty
//           ? outfitCategories.first.categoryName
//           : null;
//       print(
//         '✅ Outfit has ${outfitCategories.length} categories, selected: $selectedCategory',
//       );

//       // 8. Get all category names for dropdown
//       final userCategories = allCategories
//           .map((c) => c.categoryName ?? '')
//           .where((name) => name.isNotEmpty)
//           .toList();

//       // 9. Load items in this outfit
//       final outfitItems = await _outfitItemRepo.getByOutfitId(outfitId);
//       final List<Map<String, dynamic>> itemsWithDetails = [];

//       for (final outfitItem in outfitItems) {
//         final item = await _itemRepo.getById(outfitItem.itemId);
//         if (item != null) {
//           itemsWithDetails.add({
//             'id': item.itemId,
//             'name': item.itemName,
//             'imagePath': item.imagePath,
//           });
//         }
//       }

//       print('👕 Outfit has ${itemsWithDetails.length} items');

//       // 10. Convert outfit to Map for compatibility
//       final outfitMap = outfit.toMap();
//       outfitMap['imageUrl'] = imagePath ?? '';
//       outfitMap['items'] = itemsWithDetails;
//       outfitMap['itemCount'] = itemsWithDetails.length;
//       outfitMap['postCount'] = posts.length;
//       outfitMap['hasPosts'] = hasPosts;

//       // 11. Convert user to Map
//       final userMap = {
//         'id': currentUser.userId,
//         'email': currentUser.email,
//         'username': currentUser.username,
//         'fullName': currentUser.fullName,
//       };

//       emit(
//         state.copyWith(
//           currentUser: userMap,
//           outfit: outfitMap,
//           userCategories: userCategories,
//           name: outfit.outfitName ?? '',
//           description: outfit.description ?? '',
//           selectedCategory: selectedCategory,
//           selectedSeason: _formatSeason(outfit.season),
//           isLoading: false,
//         ),
//       );

//       print(
//         '✅ Successfully loaded outfit "${outfit.outfitName}" (ID: $outfitId)',
//       );
//       print('📊 Outfit has ${posts.length} associated posts');
//     } catch (e, stackTrace) {
//       print('❌ Error loading outfit data: $e');
//       print('Stack trace: $stackTrace');
//       emit(
//         state.copyWith(
//           isLoading: false,
//           hasError: true,
//           errorMessage: 'Failed to load outfit: ${e.toString()}',
//         ),
//       );
//     }
//   }

//   String? _formatSeason(String? season) {
//     if (season == null || season.isEmpty) return null;

//     final seasonLower = season.toLowerCase().trim();

//     if (seasonLower.contains('spring')) return 'Spring';
//     if (seasonLower.contains('summer')) return 'Summer';
//     if (seasonLower.contains('fall') || seasonLower.contains('autumn')) {
//       return 'Fall';
//     }
//     if (seasonLower.contains('winter')) return 'Winter';
//     if (seasonLower.contains('all')) return 'All Season';

//     // Capitalize first letter for custom seasons
//     return season[0].toUpperCase() + season.substring(1).toLowerCase();
//   }

//   void updateName(String name) {
//     emit(state.copyWith(name: name));
//   }

//   void updateDescription(String description) {
//     emit(state.copyWith(description: description));
//   }

//   void updateCategory(String? category) {
//     emit(state.copyWith(selectedCategory: category));
//   }

//   void updateSeason(String? season) {
//     emit(state.copyWith(selectedSeason: season));
//   }

//   Future<void> saveOutfit() async {
//     try {
//       emit(
//         state.copyWith(
//           isLoading: true,
//           errorMessage: null,
//           successMessage: null,
//         ),
//       );

//       final outfitId = int.tryParse(state.outfitId);
//       if (outfitId == null) {
//         throw Exception('Invalid outfit ID: ${state.outfitId}');
//       }

//       final currentUser = CurrentUserService.currentUser;
//       if (currentUser == null || currentUser.userId == null) {
//         throw Exception('User not logged in');
//       }

//       // Validate required fields
//       if (!state.isValid) {
//         if (state.name.trim().isEmpty) {
//           throw Exception('Please enter an outfit name');
//         }
//         if (state.selectedCategory == null || state.selectedCategory!.isEmpty) {
//           throw Exception('Please select a category');
//         }
//       }

//       print('💾 Saving outfit ID: $outfitId');
//       print('📝 Name: "${state.name}"');
//       print('📄 Description: "${state.description}"');
//       print('🏷️ Category: "${state.selectedCategory}"');
//       print('🌤️ Season: "${state.selectedSeason}"');

//       // 1. Get the current outfit to preserve other fields
//       final currentOutfit = await _outfitRepo.getById(outfitId);
//       if (currentOutfit == null) {
//         throw Exception('Outfit not found in database');
//       }

//       // 2. Update the outfit in database
//       final updatedOutfit = OutfitModel(
//         outfitId: outfitId,
//         userId: currentOutfit.userId, // Preserve original user
//         outfitName: state.name.trim(),
//         description: state.description.trim(),
//         season: _parseSeason(state.selectedSeason),
//         date: currentOutfit.date, // Keep original creation date
//       );

//       final updateSuccess = await _outfitRepo.update(outfitId, updatedOutfit);
//       if (!updateSuccess) {
//         throw Exception('Failed to update outfit in database');
//       }

//       // 3. Update categories if changed
//       if (state.selectedCategory != null &&
//           state.selectedCategory!.isNotEmpty) {
//         final category = await _categoryService.getCategoryByName(
//           state.selectedCategory!,
//         );
//         if (category != null && category.categoryId != null) {
//           await _categoryService.setOutfitCategories(outfitId, [
//             category.categoryId!,
//           ]);
//           print('✅ Updated outfit category to "${state.selectedCategory}"');
//         } else {
//           print(
//             '⚠️ Category "${state.selectedCategory}" not found in database',
//           );
//         }
//       }

//       emit(state.copyWith(
//         isLoading: false,     
//         successMessage: 'Outfit updated successfully!',
//       ));

//       print('✅ Outfit "${state.name}" saved successfully');

//       // Clear success message after 2 seconds automatically
//       _clearMessagesAfterDelay(const Duration(seconds: 2));
//     } catch (e, stackTrace) {
//       print('❌ Error saving outfit: $e');
//       print('Stack trace: $stackTrace');
//       emit(state.copyWith(
//         isLoading: false,
//         errorMessage: 'Failed to save outfit: ${e.toString()}',
//       ));

//       // Clear error message after 3 seconds automatically
//       _clearMessagesAfterDelay(const Duration(seconds: 3));
//       rethrow;
//     }
//   }

//   /// Check if outfit has posts before deletion
//   Future<bool> canDeleteOutfit() async {
//     try {
//       final outfitId = int.tryParse(state.outfitId);
//       if (outfitId == null) return false;

//       final posts = await _postRepo.getByOutfitId(outfitId);
//       return posts.isEmpty; // Can delete if no posts
//     } catch (e) {
//       print('❌ Error checking if outfit can be deleted: $e');
//       return false;
//     }
//   }

//   /// Get post count for this outfit
//   Future<int> getPostCount() async {
//     try {
//       final outfitId = int.tryParse(state.outfitId);
//       if (outfitId == null) return 0;

//       final posts = await _postRepo.getByOutfitId(outfitId);
//       return posts.length;
//     } catch (e) {
//       print('❌ Error getting post count: $e');
//       return 0;
//     }
//   }

//   Future<void> deleteOutfit() async {
//     try {
//       emit(
//         state.copyWith(
//           isLoading: true,
//           errorMessage: null,
//           successMessage: null,
//         ),
//       );

//       final outfitId = int.tryParse(state.outfitId);
//       if (outfitId == null) {
//         throw Exception('Invalid outfit ID: ${state.outfitId}');
//       }

//       final currentUser = CurrentUserService.currentUser;
//       if (currentUser == null || currentUser.userId == null) {
//         throw Exception('User not logged in');
//       }

//       print('🗑️ Starting deletion of outfit ID: $outfitId');

//       // 1. Verify outfit belongs to current user
//       final outfit = await _outfitRepo.getById(outfitId);
//       if (outfit == null) {
//         throw Exception('Outfit not found');
//       }

//       if (outfit.userId != currentUser.userId) {
//         throw Exception('You can only delete your own outfits');
//       }

//       // 2. Check for associated posts (double check)
//       final posts = await _postRepo.getByOutfitId(outfitId);
//       if (posts.isNotEmpty) {
//         throw Exception(
//           'Cannot delete outfit because it is used in ${posts.length} post(s). Please delete the post(s) first.',
//         );
//       }

//       // 3. Delete outfit image from storage
//       try {
//         await OutfitImageService.deleteOutfitImageById(outfitId);
//         print('✅ Deleted outfit image');
//       } catch (e) {
//         print('⚠️ Could not delete outfit image: $e');
//         // Continue with deletion even if image deletion fails
//       }

//       // 4. Delete outfit-category relationships
//       try {
//         await _outfitCategoryJoinRepo.deleteByOutfitId(outfitId);
//         print('✅ Deleted outfit-category relationships');
//       } catch (e) {
//         print('⚠️ Error deleting outfit-category relationships: $e');
//       }

//       // 5. Delete outfit-item relationships
//       try {
//         final outfitItems = await _outfitItemRepo.getByOutfitId(outfitId);
//         for (final outfitItem in outfitItems) {
//           await _outfitItemRepo.delete(outfitId, outfitItem.itemId);
//         }
//         print('✅ Deleted ${outfitItems.length} outfit-item relationships');
//       } catch (e) {
//         print('⚠️ Error deleting outfit-item relationships: $e');
//       }

//       // 6. Finally delete the outfit itself
//       try {
//         await _outfitRepo.delete(outfitId);
//         print('✅ Deleted outfit from database');
//       } catch (e) {
//         print('❌ Error deleting outfit from database: $e');
//         throw Exception('Failed to delete outfit from database');
//       }

//       emit(
//         state.copyWith(
//           isLoading: false,
//           isDeleted: true,
//           successMessage: 'Outfit deleted successfully!',
//         ),
//       );
//       _clearMessagesAfterDelay(const Duration(seconds: 2));

//       print('✅ Outfit deletion completed successfully');
//     } catch (e, stackTrace) {
//       print('❌ Error deleting outfit: $e');
//       print('Stack trace: $stackTrace');
//       emit(
//         state.copyWith(
//           isLoading: false,
//           errorMessage: 'Failed to delete outfit: ${e.toString()}',
//         ),
//       );
//       _clearMessagesAfterDelay(const Duration(seconds: 3));
//       rethrow;
//     }
//   }

//   String _parseSeason(String? season) {
//     if (season == null || season.isEmpty) return 'all';

//     final seasonLower = season.toLowerCase().trim();

//     if (seasonLower.contains('spring')) return 'spring';
//     if (seasonLower.contains('summer')) return 'summer';
//     if (seasonLower.contains('fall')) return 'fall';
//     if (seasonLower.contains('autumn')) return 'fall'; // Map autumn to fall
//     if (seasonLower.contains('winter')) return 'winter';
//     if (seasonLower.contains('all')) return 'all';

//     return seasonLower;
//   }

//   void refresh() {
//     emit(
//       state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
//     );
//     _loadOutfitData();
//   }

//   Future<void> _clearMessagesAfterDelay(Duration duration) async {
//     await Future.delayed(duration);
//     if (!isClosed) {
//       // Cubit has isClosed property
//       emit(state.copyWith(successMessage: null, errorMessage: null));
//     }
//   }

//   void clearMessages() {
//   emit(state.copyWith(
//     successMessage: null,
//     errorMessage: null,
//   ));
// }
// }

// ==========================================

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/repo/outfit_repo.dart';
import 'package:vestium/repo/outfit_item_repo.dart';
import 'package:vestium/repo/outfit_category_join_repo.dart';
import 'package:vestium/repo/post_repo.dart';
import 'package:vestium/repo/item_repo.dart';
import 'package:vestium/databases/services/outfit_category_service.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'package:vestium/databases/services/outfit_image_service.dart';
import 'edit_outfit_state.dart';

class EditOutfitCubit extends Cubit<EditOutfitState> {
  final OutfitRepo _outfitRepo = OutfitRepo();
  final OutfitItemRepo _outfitItemRepo = OutfitItemRepo();
  final OutfitCategoryJoinRepo _outfitCategoryJoinRepo = OutfitCategoryJoinRepo();
  final PostRepo _postRepo = PostRepo();
  final ItemRepo _itemRepo = ItemRepo();
  final OutfitCategoryService _categoryService = OutfitCategoryService();

  EditOutfitCubit({required int outfitId})
      : super(EditOutfitState(outfitId: outfitId.toString())) {
    _loadOutfitData();
  }

  Future<void> _loadOutfitData() async {
    try {
      emit(state.copyWith(isLoading: true));

      print('📄 Loading outfit data for ID: ${state.outfitId}');

      // 1. Load current user
      final currentUser = CurrentUserService.currentUser;
      if (currentUser == null || currentUser.userId == null) {
        print('❌ No user logged in');
        emit(
          state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: 'User not logged in',
          ),
        );
        return;
      }

      // 2. Load the outfit
      final outfitId = int.tryParse(state.outfitId);
      if (outfitId == null) {
        print('❌ Invalid outfit ID: ${state.outfitId}');
        emit(
          state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: 'Invalid outfit ID',
          ),
        );
        return;
      }

      final outfit = await _outfitRepo.getById(outfitId);
      if (outfit == null) {
        print('❌ Outfit not found in database: $outfitId');
        emit(
          state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: 'Outfit not found',
          ),
        );
        return;
      }

      // 3. Verify the outfit belongs to current user
      if (outfit.userId != currentUser.userId) {
        print(
          '❌ Outfit belongs to user ${outfit.userId}, but current user is ${currentUser.userId}',
        );
        emit(
          state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: 'You can only edit your own outfits',
          ),
        );
        return;
      }

      // 4. Check if outfit has associated posts
      final posts = await _postRepo.getByOutfitId(outfitId);
      final hasPosts = posts.isNotEmpty;

      // 5. Load outfit image path if exists
      final imagePath = await OutfitImageService.getOutfitImagePath(outfitId);
      print('📸 Outfit image path loaded: ${imagePath ?? "No image found"}');
      
      if (imagePath != null) {
        final file = File(imagePath);
        final exists = await file.exists();
        print('📸 Image file exists: $exists');
        if (!exists) {
          print('⚠️ WARNING: Image path returned but file does not exist!');
        }
      }

      // 6. Load all available categories from database
      await _categoryService.ensureInitialCategories();
      final allCategories = await _categoryService.getAllCategories();
      print('🏷️ Loaded ${allCategories.length} categories from database');

      // 7. Load categories for this outfit (multiple categories support)
      final outfitCategories = await _outfitCategoryJoinRepo.getCategoriesForOutfit(outfitId);
      final selectedCategories = outfitCategories
          .map((c) => c.categoryName ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
      print('✅ Outfit has ${selectedCategories.length} categories: $selectedCategories');

      // 8. Get all category names for selection
      final userCategories = allCategories
          .map((c) => c.categoryName ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      // 9. Load items in this outfit
      final outfitItems = await _outfitItemRepo.getByOutfitId(outfitId);
      final List<Map<String, dynamic>> itemsWithDetails = [];

      for (final outfitItem in outfitItems) {
        final item = await _itemRepo.getById(outfitItem.itemId);
        if (item != null) {
          itemsWithDetails.add({
            'id': item.itemId,
            'name': item.itemName,
            'imagePath': item.imagePath,
          });
        }
      }

      print('👕 Outfit has ${itemsWithDetails.length} items');

      // 10. Convert outfit to Map for compatibility
      final outfitMap = outfit.toMap();
      outfitMap['imageUrl'] = imagePath ?? '';
      outfitMap['items'] = itemsWithDetails;
      outfitMap['itemCount'] = itemsWithDetails.length;
      outfitMap['postCount'] = posts.length;
      outfitMap['hasPosts'] = hasPosts;
      
      print('🗺️ Outfit map created with imageUrl: "${outfitMap['imageUrl']}"');

      // 11. Convert user to Map
      final userMap = {
        'id': currentUser.userId,
        'email': currentUser.email,
        'username': currentUser.username,
        'fullName': currentUser.fullName,
      };

      emit(
        state.copyWith(
          currentUser: userMap,
          outfit: outfitMap,
          userCategories: userCategories,
          name: outfit.outfitName ?? '',
          description: outfit.description ?? '',
          selectedCategories: selectedCategories,
          selectedSeason: _formatSeason(outfit.season),
          isLoading: false,
          outfitItems: itemsWithDetails,
        ),
      );

      print(
        '✅ Successfully loaded outfit "${outfit.outfitName}" (ID: $outfitId)',
      );
      print('📊 Outfit has ${posts.length} associated posts');
    } catch (e, stackTrace) {
      print('❌ Error loading outfit data: $e');
      print('Stack trace: $stackTrace');
      emit(
        state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Failed to load outfit: ${e.toString()}',
        ),
      );
    }
  }

  String? _formatSeason(String? season) {
    if (season == null || season.isEmpty) return null;

    final seasonLower = season.toLowerCase().trim();

    if (seasonLower.contains('spring')) return 'Spring';
    if (seasonLower.contains('summer')) return 'Summer';
    if (seasonLower.contains('fall') || seasonLower.contains('autumn')) {
      return 'Fall';
    }
    if (seasonLower.contains('winter')) return 'Winter';
    if (seasonLower.contains('all')) return 'All Season';

    return season[0].toUpperCase() + season.substring(1).toLowerCase();
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void toggleCategory(String category) {
    final currentCategories = List<String>.from(state.selectedCategories);
    
    if (currentCategories.contains(category)) {
      currentCategories.remove(category);
    } else {
      currentCategories.add(category);
    }
    
    emit(state.copyWith(selectedCategories: currentCategories));
  }

  void updateSeason(String? season) {
    emit(state.copyWith(selectedSeason: season));
  }

  Future<void> saveOutfit() async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          errorMessage: null,
          successMessage: null,
        ),
      );

      final outfitId = int.tryParse(state.outfitId);
      if (outfitId == null) {
        throw Exception('Invalid outfit ID: ${state.outfitId}');
      }

      final currentUser = CurrentUserService.currentUser;
      if (currentUser == null || currentUser.userId == null) {
        throw Exception('User not logged in');
      }

      // Validate required fields
      if (!state.isValid) {
        if (state.name.trim().isEmpty) {
          throw Exception('Please enter an outfit name');
        }
        if (state.selectedCategories.isEmpty) {
          throw Exception('Please select at least one category');
        }
      }

      print('💾 Saving outfit ID: $outfitId');
      print('📝 Name: "${state.name}"');
      print('📄 Description: "${state.description}"');
      print('🏷️ Categories: "${state.selectedCategories}"');
      print('🌤️ Season: "${state.selectedSeason}"');

      // 1. Get the current outfit to preserve other fields
      final currentOutfit = await _outfitRepo.getById(outfitId);
      if (currentOutfit == null) {
        throw Exception('Outfit not found in database');
      }

      // 2. Update the outfit in database
      final updatedOutfit = OutfitModel(
        outfitId: outfitId,
        userId: currentOutfit.userId,
        outfitName: state.name.trim(),
        description: state.description.trim(),
        season: _parseSeason(state.selectedSeason),
        date: currentOutfit.date,
      );

      final updateSuccess = await _outfitRepo.update(outfitId, updatedOutfit);
      if (!updateSuccess) {
        throw Exception('Failed to update outfit in database');
      }

      // 3. Update categories (support multiple categories)
      if (state.selectedCategories.isNotEmpty) {
        final categoryIds = <int>[];
        
        for (final categoryName in state.selectedCategories) {
          final category = await _categoryService.getCategoryByName(categoryName);
          if (category != null && category.categoryId != null) {
            categoryIds.add(category.categoryId!);
          }
        }
        
        if (categoryIds.isNotEmpty) {
          await _categoryService.setOutfitCategories(outfitId, categoryIds);
          print('✅ Updated outfit categories to: ${state.selectedCategories}');
        }
      }

      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Outfit updated successfully!',
      ));

      print('✅ Outfit "${state.name}" saved successfully');
      _clearMessagesAfterDelay(const Duration(seconds: 2));
    } catch (e, stackTrace) {
      print('❌ Error saving outfit: $e');
      print('Stack trace: $stackTrace');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save outfit: ${e.toString()}',
      ));
      _clearMessagesAfterDelay(const Duration(seconds: 3));
      rethrow;
    }
  }

  Future<bool> canDeleteOutfit() async {
    try {
      final outfitId = int.tryParse(state.outfitId);
      if (outfitId == null) return false;

      final posts = await _postRepo.getByOutfitId(outfitId);
      return posts.isEmpty;
    } catch (e) {
      print('❌ Error checking if outfit can be deleted: $e');
      return false;
    }
  }

  Future<int> getPostCount() async {
    try {
      final outfitId = int.tryParse(state.outfitId);
      if (outfitId == null) return 0;

      final posts = await _postRepo.getByOutfitId(outfitId);
      return posts.length;
    } catch (e) {
      print('❌ Error getting post count: $e');
      return 0;
    }
  }

  Future<void> deleteOutfit() async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          errorMessage: null,
          successMessage: null,
        ),
      );

      final outfitId = int.tryParse(state.outfitId);
      if (outfitId == null) {
        throw Exception('Invalid outfit ID: ${state.outfitId}');
      }

      final currentUser = CurrentUserService.currentUser;
      if (currentUser == null || currentUser.userId == null) {
        throw Exception('User not logged in');
      }

      print('🗑️ Starting deletion of outfit ID: $outfitId');

      final outfit = await _outfitRepo.getById(outfitId);
      if (outfit == null) {
        throw Exception('Outfit not found');
      }

      if (outfit.userId != currentUser.userId) {
        throw Exception('You can only delete your own outfits');
      }

      final posts = await _postRepo.getByOutfitId(outfitId);
      if (posts.isNotEmpty) {
        throw Exception(
          'Cannot delete outfit because it is used in ${posts.length} post(s). Please delete the post(s) first.',
        );
      }

      try {
        await OutfitImageService.deleteOutfitImageById(outfitId);
        print('✅ Deleted outfit image');
      } catch (e) {
        print('⚠️ Could not delete outfit image: $e');
      }

      try {
        await _outfitCategoryJoinRepo.deleteByOutfitId(outfitId);
        print('✅ Deleted outfit-category relationships');
      } catch (e) {
        print('⚠️ Error deleting outfit-category relationships: $e');
      }

      try {
        final outfitItems = await _outfitItemRepo.getByOutfitId(outfitId);
        for (final outfitItem in outfitItems) {
          await _outfitItemRepo.delete(outfitId, outfitItem.itemId);
        }
        print('✅ Deleted ${outfitItems.length} outfit-item relationships');
      } catch (e) {
        print('⚠️ Error deleting outfit-item relationships: $e');
      }

      try {
        await _outfitRepo.delete(outfitId);
        print('✅ Deleted outfit from database');
      } catch (e) {
        print('❌ Error deleting outfit from database: $e');
        throw Exception('Failed to delete outfit from database');
      }

      emit(
        state.copyWith(
          isLoading: false,
          isDeleted: true,
          successMessage: 'Outfit deleted successfully!',
        ),
      );
      _clearMessagesAfterDelay(const Duration(seconds: 2));

      print('✅ Outfit deletion completed successfully');
    } catch (e, stackTrace) {
      print('❌ Error deleting outfit: $e');
      print('Stack trace: $stackTrace');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to delete outfit: ${e.toString()}',
        ),
      );
      _clearMessagesAfterDelay(const Duration(seconds: 3));
      rethrow;
    }
  }

  String _parseSeason(String? season) {
    if (season == null || season.isEmpty) return 'all';

    final seasonLower = season.toLowerCase().trim();

    if (seasonLower.contains('spring')) return 'spring';
    if (seasonLower.contains('summer')) return 'summer';
    if (seasonLower.contains('fall')) return 'fall';
    if (seasonLower.contains('autumn')) return 'fall';
    if (seasonLower.contains('winter')) return 'winter';
    if (seasonLower.contains('all')) return 'all';

    return seasonLower;
  }

  void refresh() {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );
    _loadOutfitData();
  }

  Future<void> _clearMessagesAfterDelay(Duration duration) async {
    await Future.delayed(duration);
    if (!isClosed) {
      emit(state.copyWith(successMessage: null, errorMessage: null));
    }
  }

  void clearMessages() {
    emit(state.copyWith(
      successMessage: null,
      errorMessage: null,
    ));
  }
}