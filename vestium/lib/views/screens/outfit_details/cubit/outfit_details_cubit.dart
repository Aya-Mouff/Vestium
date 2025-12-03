import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/data/dummy/dummy-data-loader.dart';
import 'outfit_details_state.dart';

class OutfitDetailsCubit extends Cubit<OutfitDetailsState> {
  OutfitDetailsCubit({required String outfitId})
      : super(OutfitDetailsState(outfitId: outfitId)) {
    _loadOutfitDetails();
  }

  Future<void> _loadOutfitDetails() async {
    try {
      final data = await DummyDataLoader.loadDummyData();
      final outfits = data['outfits'] as List<dynamic>;
      final wardrobeItems = data['clothingItems'] as List<dynamic>;

      // Find the outfit by ID
      final foundOutfit = outfits.cast<Map<String, dynamic>?>().firstWhere(
        (o) => o?['id'].toString() == state.outfitId,
        orElse: () => null,
      );

      if (foundOutfit != null) {
        // Get the items that belong to this outfit
        final List<dynamic> outfitItems = [];

        if (foundOutfit['items'] != null) {
          for (final itemId in (foundOutfit['items'] as List<dynamic>)) {
            final foundItem = wardrobeItems
                .cast<Map<String, dynamic>?>()
                .firstWhere(
                  (item) => item?['id'].toString() == itemId.toString(),
                  orElse: () => null,
                );
            if (foundItem != null) {
              outfitItems.add(foundItem);
            }
          }
        }

        emit(state.copyWith(
          outfit: foundOutfit,
          items: outfitItems,
          isLoading: false,
        ));
      } else {
        // Outfit not found
        emit(state.copyWith(
          outfit: {},
          items: [],
          isLoading: false,
        ));
      }
    } catch (e) {
      print('Error loading outfit details: $e');
      emit(state.copyWith(
        outfit: {},
        items: [],
        isLoading: false,
        hasError: true,
      ));
    }
  }

  void refresh() {
    emit(state.copyWith(isLoading: true));
    _loadOutfitDetails();
  }
}