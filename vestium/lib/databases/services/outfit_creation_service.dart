// import 'package:flutter/material.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';

/// Service to share outfit creation data between CreateOutfitScreen and SaveOutfitScreen
class OutfitCreationService {
  static CreateOutfitCubit? _currentCubit;
  static List<PlacedItemModel>? _currentPlacedItems;
  
  /// Set the current outfit data when navigating to SaveOutfitScreen
  static void setCurrentOutfitData({
    required CreateOutfitCubit cubit,
    required List<PlacedItemModel> placedItems,
  }) {
    _currentCubit = cubit;
    _currentPlacedItems = placedItems;
    print('✅ OutfitCreationService: Data stored for ${placedItems.length} items');
  }
  
  /// Get the current CreateOutfitCubit
  static CreateOutfitCubit? getCurrentCubit() => _currentCubit;
  
  /// Get the current placed items
  static List<PlacedItemModel>? getCurrentPlacedItems() => _currentPlacedItems;
  
  /// Check if data is available
  static bool hasData() => _currentCubit != null && _currentPlacedItems != null;
  
  /// Clear the stored data (call after saving)
  static void clear() {
    _currentCubit = null;
    _currentPlacedItems = null;
    print('✅ OutfitCreationService: Data cleared');
  }
  
  /// Validate that we have valid data
  static bool validateData() {
    if (_currentCubit == null) {
      print('❌ OutfitCreationService: No cubit available');
      return false;
    }
    
    if (_currentPlacedItems == null) {
      print('❌ OutfitCreationService: No placed items available');
      return false;
    }
    
    if (_currentPlacedItems!.isEmpty) {
      print('❌ OutfitCreationService: Placed items list is empty');
      return false;
    }
    
    return true;
  }
}