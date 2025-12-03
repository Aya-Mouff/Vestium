import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/data/dummy/dummy-data-loader.dart';
import 'edit_outfit_state.dart';

class EditOutfitCubit extends Cubit<EditOutfitState> {
  EditOutfitCubit({required String outfitId})
      : super(EditOutfitState(outfitId: outfitId)) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await DummyDataLoader.loadDummyData();
      final outfits = data['outfits'] as List<dynamic>;
      final users = data['users'] as List<dynamic>;

      // Get current user (user with id "1")
      final user = users.cast<Map<String, dynamic>?>().firstWhere(
        (u) => u?['id'].toString() == '1',
        orElse: () => null,
      );

      // Find the outfit by ID
      final foundOutfit = outfits.cast<Map<String, dynamic>?>().firstWhere(
        (o) => o?['id'].toString() == state.outfitId,
        orElse: () => null,
      );

      if (foundOutfit != null && user != null) {
        // Get user's custom outfit categories
        final customCategories = user['customOutfitCategories'] as List<dynamic>?;
        
        // Handle season - could be string or array
        String? selectedSeason;
        final season = foundOutfit['season'];
        if (season is String) {
          selectedSeason = season == 'all' ? 'All Season' : _capitalizeFirstLetter(season);
        } else if (season is List && season.isNotEmpty) {
          selectedSeason = _capitalizeFirstLetter(season[0].toString());
        }

        emit(state.copyWith(
          currentUser: user,
          outfit: foundOutfit,
          userCategories: customCategories?.cast<String>().toList() ?? state.userCategories,
          name: foundOutfit['name'] ?? '',
          description: foundOutfit['description'] ?? '',
          selectedCategory: foundOutfit['category'],
          selectedSeason: selectedSeason,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
        ));
      }
    } catch (e) {
      print('Error loading data: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
      ));
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateCategory(String? category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void updateSeason(String? season) {
    emit(state.copyWith(selectedSeason: season));
  }

  void refresh() {
    emit(state.copyWith(isLoading: true));
    _loadData();
  }
}