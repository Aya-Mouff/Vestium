import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/databases/services/outfit_category_service.dart';
import 'package:vestium/repo/outfit_repo.dart';
import 'package:vestium/repo/outfit_item_repo.dart';
import 'package:vestium/repo/outfit_category_join_repo.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';
import 'package:vestium/databases/services/outfit_composite_image_service.dart'; // NEW IMPORT
import 'save_outfit_state.dart';

class SaveOutfitCubit extends Cubit<SaveOutfitState> {
  final OutfitCategoryService _outfitCategoryService;
  final OutfitRepo _outfitRepo = OutfitRepo();
  final OutfitItemRepo _outfitItemRepo = OutfitItemRepo();
  final OutfitCategoryJoinRepo _outfitCategoryJoinRepo = OutfitCategoryJoinRepo();
  final List<PlacedItemModel> _placedItems;

  SaveOutfitCubit({
    required CreateOutfitCubit createOutfitCubit,
    required List<PlacedItemModel> placedItems,
    OutfitCategoryService? outfitCategoryService,
  }) : _placedItems = placedItems,
       _outfitCategoryService = outfitCategoryService ?? OutfitCategoryService(),
       super(const SaveOutfitInitial()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      emit(const SaveOutfitLoading());

      // Get current user id
      final userId = CurrentUserService.currentUserId;
      if (userId == null) {
        throw Exception('No user logged in');
      }

      // Ensure initial categories exist for this user
      await _outfitCategoryService.ensureInitialCategoriesForUser(userId);

      // Load all categories for this user
      final allCategories = await _outfitCategoryService.getAllCategoriesForUser(userId);

      emit(SaveOutfitDataLoaded(allCategories: allCategories, itemsCount: _placedItems.length));
    } catch (e) {
      print('❌ Error loading outfit categories: $e');
      emit(SaveOutfitError('Failed to load categories: $e'));
    }
  }

  void updateOutfitName(String name) {
    if (state is! SaveOutfitDataLoaded) return;
    final currentState = state as SaveOutfitDataLoaded;
    emit(currentState.copyWith(outfitName: name));
  }

  void updateDescription(String desc) {
    if (state is! SaveOutfitDataLoaded) return;
    final currentState = state as SaveOutfitDataLoaded;
    emit(currentState.copyWith(description: desc));
  }

  void updateSeason(String? season) {
    if (state is! SaveOutfitDataLoaded) return;
    final currentState = state as SaveOutfitDataLoaded;
    emit(currentState.copyWith(selectedSeason: season));
  }

  void toggleCategory(int categoryId) {
    if (state is! SaveOutfitDataLoaded) return;
    final currentState = state as SaveOutfitDataLoaded;

    List<int> updatedCategories;
    if (currentState.selectedCategoryIds.contains(categoryId)) {
      updatedCategories = List.from(currentState.selectedCategoryIds)..remove(categoryId);
    } else {
      updatedCategories = List.from(currentState.selectedCategoryIds)..add(categoryId);
    }

    emit(currentState.copyWith(selectedCategoryIds: updatedCategories));
  }

  Future<bool> saveOutfit() async {
    try {
      if (state is! SaveOutfitDataLoaded) {
        throw Exception('Invalid state for saving outfit');
      }

      final currentState = state as SaveOutfitDataLoaded;

      // Validation
      if (currentState.outfitName.trim().isEmpty) {
        throw Exception('Please enter an outfit name');
      }

      if (_placedItems.isEmpty) {
        throw Exception('Outfit must contain at least one item');
      }

      emit(currentState.copyWith(isSaving: true));

      final currentUserId = CurrentUserService.currentUserId;
      if (currentUserId == null) {
        throw Exception('No user logged in');
      }

      // Create outfit model
      final now = DateTime.now().toIso8601String();
      final outfit = OutfitModel(
        userId: currentUserId,
        outfitName: currentState.outfitName.trim(),
        description: currentState.description.isNotEmpty ? currentState.description.trim() : null,
        season: currentState.selectedSeason ?? 'All',
        date: now,
      );

      // Insert outfit into database
      final outfitId = await _outfitRepo.insert(outfit);
      print('✅ Outfit "${currentState.outfitName}" inserted with ID: $outfitId');

      // Get the inserted outfit
      final savedOutfit = OutfitModel(
        outfitId: outfitId,
        userId: currentUserId,
        outfitName: currentState.outfitName.trim(),
        description: currentState.description.isNotEmpty ? currentState.description.trim() : null,
        season: currentState.selectedSeason ?? 'All',
        date: now,
      );

      // Add items to outfit_item junction table
      print('📝 Adding ${_placedItems.length} items to outfit...');
      for (final placedItem in _placedItems) {
        final outfitItem = OutfitItem(outfitId: outfitId, itemId: placedItem.itemId);
        await _outfitItemRepo.insert(outfitItem);
      }
      print('✅ All items added to outfit');

      // Add categories to outfit_category_join table
      if (currentState.selectedCategoryIds.isNotEmpty) {
        print('🏷️  Adding ${currentState.selectedCategoryIds.length} categories...');
        for (final categoryId in currentState.selectedCategoryIds) {
          final join = OutfitCategoryJoin(outfitId: outfitId, categoryId: categoryId);
          await _outfitCategoryJoinRepo.insert(join);
        }
        print('✅ Categories added to outfit');
      }

      // === CREATE AND SAVE COMPOSITE OUTFIT IMAGE ===
      String? savedOutfitImagePath;
      try {
        print('🎨 Creating composite outfit image...');

        savedOutfitImagePath = await OutfitCompositeImageService.createCompositeImage(
          placedItems: _placedItems,
          outfitId: outfitId,
          userId: currentUserId,
        );

        if (savedOutfitImagePath != null) {
          print('✅ Composite outfit image created and saved: $savedOutfitImagePath');

          // If you want to create a post for the gallery, you can do it here
          // await _createOutfitPost(savedOutfit, savedOutfitImagePath, currentUserId);
        } else {
          print('⚠️  Could not create composite image, trying grid layout...');

          // Try grid layout as fallback
          savedOutfitImagePath = await OutfitCompositeImageService.createGridCompositeImage(
            placedItems: _placedItems,
            outfitId: outfitId,
            userId: currentUserId,
          );

          if (savedOutfitImagePath != null) {
            print('✅ Grid composite image saved: $savedOutfitImagePath');
          } else {
            print('⚠️  Could not create any outfit image');
          }
        }
      } catch (e) {
        print('⚠️  Error creating outfit image: $e');
        // Don't fail the entire save if image creation fails
      }

      emit(SaveOutfitSaved(outfit: savedOutfit));
      print('🎉 Outfit saved successfully with ID: $outfitId');
      return true;
    } catch (e) {
      print('❌ Error saving outfit: $e');
      if (state is SaveOutfitDataLoaded) {
        final currentState = state as SaveOutfitDataLoaded;
        emit(currentState.copyWith(isSaving: false));
      }
      emit(SaveOutfitError('Failed to save outfit: $e'));
      return false;
    }
  }
}
