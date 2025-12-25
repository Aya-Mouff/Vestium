// widgets/saved_outfits_grid.dart
import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../../../../databases/db_models.dart';
import '../../../../databases/services/outfit_image_service.dart';
import 'saved_outfit_card.dart';
import 'empty_state.dart';

class SavedOutfitsGrid extends StatelessWidget {
  final bool isLoading;
  final List<OutfitModel> outfits;
  final OutfitModel? selectedOutfit;
  final VoidCallback onRetry;
  final ValueChanged<OutfitModel?> onSelect;

  const SavedOutfitsGrid({
    super.key,
    required this.isLoading,
    required this.outfits,
    required this.selectedOutfit,
    required this.onRetry,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (outfits.isEmpty) {
      return EmptyState(title: loc.selectOutfitNoOutfits, message: loc.selectOutfitCreateFirst);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];
          final isSelected = selectedOutfit != null && selectedOutfit!.outfitId == outfit.outfitId;

          return FutureBuilder<String?>(
            future: OutfitImageService.getOutfitImagePath(outfit.outfitId!),
            builder: (context, snapshot) {
              return SavedOutfitCard(
                outfit: outfit,
                isSelected: isSelected,
                onTap: () => onSelect(isSelected ? null : outfit),
                imagePath: snapshot.data,
                date: outfit.date,
              );
            },
          );
        },
      ),
    );
  }
}
