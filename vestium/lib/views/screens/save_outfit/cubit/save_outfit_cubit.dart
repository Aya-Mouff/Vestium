import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/databases/services/outfit_category_service.dart';
import 'package:vestium/repo/outfit_repo.dart';
import 'package:vestium/repo/outfit_item_repo.dart';
import 'package:vestium/repo/outfit_category_join_repo.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';
import 'package:vestium/databases/services/outfit_screenshot_service.dart';
import 'package:vestium/databases/services/outfit_image_service.dart'; // ⭐ ADD THIS IMPORT
import 'save_outfit_state.dart';
import 'dart:io';

class SaveOutfitCubit extends Cubit<SaveOutfitState> {
  final OutfitCategoryService _outfitCategoryService;
  final OutfitRepo _outfitRepo = OutfitRepo();
  final OutfitItemRepo _outfitItemRepo = OutfitItemRepo();
  final OutfitCategoryJoinRepo _outfitCategoryJoinRepo =
      OutfitCategoryJoinRepo();
  final List<PlacedItemModel> _placedItems;
  final GlobalKey? _canvasKey;
  final String? _preCapturedImagePath;

  SaveOutfitCubit({
    required CreateOutfitCubit createOutfitCubit,
    required List<PlacedItemModel> placedItems,
    GlobalKey? canvasKey,
    String? preCapturedImagePath,
    OutfitCategoryService? outfitCategoryService,
  }) : _placedItems = placedItems,
       _canvasKey = canvasKey,
       _preCapturedImagePath = preCapturedImagePath,
       _outfitCategoryService =
           outfitCategoryService ?? OutfitCategoryService(),
       super(const SaveOutfitInitial()) {
    print('🔧 SaveOutfitCubit initialized with:');
    print('   - Items: ${placedItems.length}');
    print('   - Canvas key: ${canvasKey != null ? "PRESENT ✅" : "MISSING ❌"}');
    print(
      '   - Pre-captured image: ${preCapturedImagePath != null ? "PRESENT ✅" : "NOT PROVIDED ❌"}',
    );
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      emit(const SaveOutfitLoading());

      await _outfitCategoryService.ensureInitialCategories();
      final allCategories = await _outfitCategoryService.getAllCategories();

      emit(
        SaveOutfitDataLoaded(
          allCategories: allCategories,
          itemsCount: _placedItems.length,
          preCapturedImagePath: _preCapturedImagePath,
        ),
      );
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
      updatedCategories = List.from(currentState.selectedCategoryIds)
        ..remove(categoryId);
    } else {
      updatedCategories = List.from(currentState.selectedCategoryIds)
        ..add(categoryId);
    }

    emit(currentState.copyWith(selectedCategoryIds: updatedCategories));
  }

  Future<bool> saveOutfit() async {
    print('\n🎯 ============ SAVE OUTFIT STARTED ============');

    try {
      if (state is! SaveOutfitDataLoaded) {
        throw Exception('Invalid state for saving outfit');
      }

      final currentState = state as SaveOutfitDataLoaded;

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

      print('👤 User ID: $currentUserId');
      print('📝 Outfit Name: ${currentState.outfitName}');
      print('🏷️ Categories: ${currentState.selectedCategoryIds.length}');
      print('👔 Items: ${_placedItems.length}');

      final now = DateTime.now().toIso8601String();
      final outfit = OutfitModel(
        userId: currentUserId,
        outfitName: currentState.outfitName.trim(),
        description: currentState.description.isNotEmpty
            ? currentState.description.trim()
            : null,
        season: currentState.selectedSeason ?? 'All',
        date: now,
      );

      // Insert outfit
      final outfitId = await _outfitRepo.insert(outfit);
      print('✅ Outfit inserted with ID: $outfitId');

      final savedOutfit = OutfitModel(
        outfitId: outfitId,
        userId: currentUserId,
        outfitName: currentState.outfitName.trim(),
        description: currentState.description.isNotEmpty
            ? currentState.description.trim()
            : null,
        season: currentState.selectedSeason ?? 'All',
        date: now,
      );

      // Add items
      print('📦 Adding items to outfit...');
      for (final placedItem in _placedItems) {
        final outfitItem = OutfitItem(
          outfitId: outfitId,
          itemId: placedItem.itemId,
        );
        await _outfitItemRepo.insert(outfitItem);
        print('   ✓ Item ${placedItem.itemId} linked');
      }

      // Add categories
      if (currentState.selectedCategoryIds.isNotEmpty) {
        print('🏷️ Adding categories...');
        for (final categoryId in currentState.selectedCategoryIds) {
          final join = OutfitCategoryJoin(
            outfitId: outfitId,
            categoryId: categoryId,
          );
          await _outfitCategoryJoinRepo.insert(join);
          print('   ✓ Category $categoryId linked');
        }
      }

      // === IMAGE HANDLING - USE PRE-CAPTURED IMAGE IF AVAILABLE ===
      print('\n📸 ============ IMAGE HANDLING PHASE ============');

      String? savedOutfitImagePath;

      if (_preCapturedImagePath != null) {
        print('✅ Using pre-captured image from outfit creation:');
        print('   Temp path: $_preCapturedImagePath');

        // Check if file exists
        final tempFile = File(_preCapturedImagePath);
        if (await tempFile.exists()) {
          print(
            '✅ Temp file exists (${(await tempFile.length()) / 1024} KB), saving as permanent outfit image...',
          );

          savedOutfitImagePath = await OutfitImageService.saveOutfitImage(
            _preCapturedImagePath,
            outfitId: outfitId,
            userId: currentUserId,
          );

          print('🎉 Image saved via OutfitImageService: $savedOutfitImagePath');

          if (state is SaveOutfitDataLoaded) {
            final currentState = state as SaveOutfitDataLoaded;
            emit(
              currentState.copyWith(preCapturedImagePath: savedOutfitImagePath),
            );
          }

          // Clean up the temp file
          try {
            await tempFile.delete();
            print('✅ Temp file deleted');
          } catch (e) {
            print('⚠️ Could not delete temp file: $e');
          }
        } else {
          print(
            '⚠️ Pre-captured image file not found at: $_preCapturedImagePath',
          );
        }
      } else {
        print('⚠️ No pre-captured image provided');
        print(
          'Canvas key status: ${_canvasKey != null ? "AVAILABLE ✅" : "NULL ❌"}',
        );

        if (_canvasKey != null) {
          print('📸 Attempting to capture screenshot now...');
          try {
            savedOutfitImagePath =
                await OutfitScreenshotService.captureAndCropOutfit(
                  canvasKey: _canvasKey,
                  outfitId: outfitId,
                  userId: currentUserId,
                  padding: 20.0,
                  quality: 3.0,
                );

            if (savedOutfitImagePath != null) {
              print('🎉 Screenshot captured: $savedOutfitImagePath');
            } else {
              print('⚠️ Screenshot capture returned null');
            }
          } catch (screenshotError) {
            print('❌ Error capturing screenshot: $screenshotError');
          }
        } else {
          print('❌ No canvas key - cannot capture screenshot');
        }
      }

      print('📸 Image handling complete');
      print('   Final image path: ${savedOutfitImagePath ?? "NONE"}');
      print('============ IMAGE HANDLING END ============\n');

      emit(SaveOutfitSaved(outfit: savedOutfit));
      print('🎉 Outfit saved successfully!');
      print('============ SAVE OUTFIT COMPLETE ============\n');
      return true;
    } catch (e, stackTrace) {
      print('❌ ERROR in saveOutfit():');
      print('   Error: $e');
      print('   Stack: $stackTrace');

      if (state is SaveOutfitDataLoaded) {
        final currentState = state as SaveOutfitDataLoaded;
        emit(currentState.copyWith(isSaving: false));
      }
      emit(SaveOutfitError('Failed to save outfit: $e'));
      return false;
    }
  }
}
