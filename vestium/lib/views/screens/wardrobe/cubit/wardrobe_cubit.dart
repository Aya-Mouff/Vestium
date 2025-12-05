// lib/wardrobe_screen/wardrobe_cubit/wardrobe_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/databases/services/item_category_service.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/repo/item_repo.dart';
import 'package:vestium/repo/item_category_repo.dart';
import 'package:vestium/repo/item_category_join_repo.dart';
import 'wardrobe_state.dart';

class WardrobeCubit extends Cubit<WardrobeState> {
  final ItemCategoryService _itemCategoryService;
  final int _userId;

  WardrobeCubit({
    required int userId,
    ItemCategoryService? itemCategoryService, // Make optional
  })  : _userId = userId,
        _itemCategoryService = itemCategoryService ?? ItemCategoryService(
          itemRepo: ItemRepo(),
          categoryRepo: ItemCategoryRepo(),
          joinRepo: ItemCategoryJoinRepo(),
        ),
        super(const WardrobeState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Load all items for the current user
      final items = await _itemCategoryService.getItemsByUserId(_userId);
      
      // Load all categories
      final categories = await _itemCategoryService.getAllCategories();
      
      emit(state.copyWith(
        isLoading: false,
        items: items,
        categories: categories,
      ));
      
      print('✅ Loaded ${items.length} items for user $_userId');
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load wardrobe items: $e',
      ));
      print('❌ Error loading wardrobe data: $e');
    }
  }

  Future<void> changeFilter(String filter) async {
    if (filter == state.selectedFilter) return;

    emit(state.copyWith(
      selectedFilter: filter,
      isLoading: true,
      errorMessage: null,
    ));

    try {
      List<ItemModel> items;
      
      if (filter == 'All' || filter == '+') {
        items = await _itemCategoryService.getItemsByUserId(_userId);
      } else {
        items = await _itemCategoryService.getItemsByUserIdAndCategory(
          _userId,
          filter,
        );
      }

      emit(state.copyWith(
        isLoading: false,
        items: items,
      ));
      
      print('✅ Filter "$filter" applied: ${items.length} items');
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to apply filter: $e',
      ));
      print('❌ Error applying filter: $e');
    }
  }

  Future<List<ItemCategory>> getCategoriesForItem(int itemId) async {
    return await _itemCategoryService.getCategoriesForItem(itemId);
  }

  Future<void> refresh() async {
    await _loadInitialData();
  }
}