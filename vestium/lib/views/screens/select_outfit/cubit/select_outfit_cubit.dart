// select_outfit/cubit/select_outfit_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'select_outfit_state.dart';
import '../../../../repo/outfit_repo.dart';
import '../../../../databases/db_models.dart';

class SelectOutfitCubit extends Cubit<SelectOutfitState> {
  final OutfitRepo _outfitRepo;

  SelectOutfitCubit({
    required int userId,
    required OutfitRepo outfitRepo,
  })  : _outfitRepo = outfitRepo,
        super(SelectOutfitState.initial(userId));

  int get userId => state.userId;

  void init() {
    if (userId == -1) return;
    loadSavedOutfits();
  }

  Future<void> loadSavedOutfits() async {
    emit(state.copyWith(isLoadingSaved: true, savedError: null));
    try {
      final outfits = await _outfitRepo.getByUserId(userId);
      emit(
        state.copyWith(
          savedOutfits: outfits,
          isLoadingSaved: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingSaved: false,
          savedError: 'Failed to load outfits',
        ),
      );
    }
  }

  void changeTab(int index) {
    emit(
      state.copyWith(
        currentTabIndex: index,
        selectedOutfit: null,
      ),
    );
  }

  void selectOutfit(OutfitModel? outfit) {
    emit(state.copyWith(selectedOutfit: outfit));
  }
}
