// select_outfit/cubit/select_outfit_state.dart
import 'package:equatable/equatable.dart';
import '../../../../databases/db_models.dart'; // where OutfitModel is

class SelectOutfitState extends Equatable {
  final int userId;
  final int currentTabIndex;
  final OutfitModel? selectedOutfit;
  final List<OutfitModel> savedOutfits;
  final bool isLoadingSaved;
  final String? savedError;

  const SelectOutfitState({
    required this.userId,
    required this.currentTabIndex,
    required this.selectedOutfit,
    required this.savedOutfits,
    required this.isLoadingSaved,
    required this.savedError,
  });

  factory SelectOutfitState.initial(int userId) {
    return SelectOutfitState(
      userId: userId,
      currentTabIndex: 0,
      selectedOutfit: null,
      savedOutfits: const [],
      isLoadingSaved: false,
      savedError: null,
    );
  }

  SelectOutfitState copyWith({
    int? userId,
    int? currentTabIndex,
    OutfitModel? selectedOutfit,
    List<OutfitModel>? savedOutfits,
    bool? isLoadingSaved,
    String? savedError,
  }) {
    return SelectOutfitState(
      userId: userId ?? this.userId,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      selectedOutfit: selectedOutfit ?? this.selectedOutfit,
      savedOutfits: savedOutfits ?? this.savedOutfits,
      isLoadingSaved: isLoadingSaved ?? this.isLoadingSaved,
      savedError: savedError ?? this.savedError,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        currentTabIndex,
        selectedOutfit,
        savedOutfits,
        isLoadingSaved,
        savedError,
      ];
}
