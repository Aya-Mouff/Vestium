// import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
// import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';

// /// Service to temporarily store outfit creation data for passing between screens
// class OutfitCreationService {
//   static CreateOutfitCubit? _currentCubit;
//   static List<PlacedItemModel>? _currentPlacedItems;

//   /// Store the current outfit creation data
//   static void setCurrentOutfitData({
//     required CreateOutfitCubit cubit,
//     required List<PlacedItemModel> placedItems,
//   }) {
//     _currentCubit = cubit;
//     _currentPlacedItems = List.from(placedItems);
    
//     print('📦 OutfitCreationService: Stored ${placedItems.length} items');
//   }

//   /// Get the currently stored cubit
//   static CreateOutfitCubit? getCurrentCubit() {
//     return _currentCubit;
//   }

//   /// Get the currently stored placed items
//   static List<PlacedItemModel>? getCurrentPlacedItems() {
//     return _currentPlacedItems;
//   }

//   /// Clear all stored data
//   static void clear() {
//     _currentCubit = null;
//     _currentPlacedItems = null;
//     print('🧹 OutfitCreationService: Cleared all data');
//   }

//   /// Check if data is currently stored
//   static bool hasData() {
//     return _currentCubit != null && _currentPlacedItems != null;
//   }
// }

// =============================================================================

import 'package:flutter/material.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';

/// Service to temporarily store outfit creation data for passing between screens
class OutfitCreationService {
  static CreateOutfitCubit? _currentCubit;
  static List<PlacedItemModel>? _currentPlacedItems;
  static GlobalKey? _canvasKey;
  static String? _capturedImagePath;

  /// Store the current outfit creation data
  static void setCurrentOutfitData({
    required CreateOutfitCubit cubit,
    required List<PlacedItemModel> placedItems,
    GlobalKey? canvasKey,
    String? capturedImagePath,
  }) {
    _currentCubit = cubit;
    _currentPlacedItems = List.from(placedItems);
    _canvasKey = canvasKey;
    _capturedImagePath = capturedImagePath;
    
    print('📦 OutfitCreationService: Stored ${placedItems.length} items');
    if (canvasKey != null) {
      print('   Canvas key stored');
    }
    if (capturedImagePath != null) {
      print('   Captured image path: $capturedImagePath');
    }
  }

  /// Get the currently stored cubit
  static CreateOutfitCubit? getCurrentCubit() {
    return _currentCubit;
  }

  /// Get the currently stored placed items
  static List<PlacedItemModel>? getCurrentPlacedItems() {
    return _currentPlacedItems;
  }

  /// Get the canvas key for screenshot capture
  static GlobalKey? getCanvasKey() {
    return _canvasKey;
  }

  /// Get the captured image path for the outfit
  static String? getCapturedImagePath() {
    return _capturedImagePath;
  }

  /// Clear all stored data
  static void clear() {
    _currentCubit = null;
    _currentPlacedItems = null;
    _canvasKey = null;
    _capturedImagePath = null;
    print('🧹 OutfitCreationService: Cleared all data');
  }

  /// Check if data is currently stored
  static bool hasData() {
    return _currentCubit != null && _currentPlacedItems != null;
  }
}