import 'package:equatable/equatable.dart';

class OutfitDetailsState extends Equatable {
  final String outfitId;
  final Map<String, dynamic>? outfit;
  final List<dynamic> items;
  final bool isLoading;
  final bool hasError;

  const OutfitDetailsState({
    required this.outfitId,
    this.outfit,
    this.items = const [],
    this.isLoading = true,
    this.hasError = false,
  });

  @override
  List<Object?> get props => [
        outfitId,
        outfit,
        items,
        isLoading,
        hasError,
      ];

  OutfitDetailsState copyWith({
    String? outfitId,
    Map<String, dynamic>? outfit,
    List<dynamic>? items,
    bool? isLoading,
    bool? hasError,
  }) {
    return OutfitDetailsState(
      outfitId: outfitId ?? this.outfitId,
      outfit: outfit ?? this.outfit,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}