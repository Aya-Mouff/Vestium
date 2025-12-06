import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/create_outfit_cubit.dart';
import '../cubit/create_outfit_state.dart';

/// Dialog for saving outfit
class SaveOutfitDialog extends StatefulWidget {
  final CreateOutfitCubit cubit;

  const SaveOutfitDialog({super.key, required this.cubit});

  @override
  State<SaveOutfitDialog> createState() => _SaveOutfitDialogState();
}

class _SaveOutfitDialogState extends State<SaveOutfitDialog> {
  final _outfitNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedSeason;
  int? _selectedCategory;

  @override
  void dispose() {
    _outfitNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveOutfit() async {
    if (_outfitNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an outfit name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await widget.cubit.saveOutfit(
      outfitName: _outfitNameController.text.trim(),
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text.trim(),
      season: _selectedSeason,
      categoryId: _selectedCategory,
    );

    if (mounted) {
      Navigator.pop(context, success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, minWidth: 280),
        child: BlocBuilder<CreateOutfitCubit, CreateOutfitState>(
          bloc: widget.cubit,
          builder: (context, state) {
            final isSaving = state is CreateOutfitSaving;
            final itemsCount = state is CreateOutfitItemsLoaded
                ? state.placedItems.length
                : 0;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Save Outfit',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Outfit Name Input
                    TextField(
                      controller: _outfitNameController,
                      enabled: !isSaving,
                      decoration: InputDecoration(
                        hintText: 'Enter outfit name',
                        filled: true,
                        fillColor: const Color(0xFFF0EBE6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'inter'),
                    ),
                    const SizedBox(height: 16),

                    // Description Input
                    TextField(
                      controller: _descriptionController,
                      enabled: !isSaving,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add description (optional)',
                        filled: true,
                        fillColor: const Color(0xFFF0EBE6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'inter'),
                    ),
                    const SizedBox(height: 16),

                    // Season Selector
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSeason,
                      hint: const Text('Select Season (optional)'),
                      items: ['Spring', 'Summer', 'Fall', 'Winter']
                          .map(
                            (season) => DropdownMenuItem(
                              value: season,
                              child: Text(season),
                            ),
                          )
                          .toList(),
                      onChanged: isSaving
                          ? null
                          : (value) => setState(() => _selectedSeason = value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF0EBE6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Items Count Info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EBE6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.layers,
                            color: Color(0xFF6B5344),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$itemsCount item${itemsCount != 1 ? 's' : ''} in outfit',
                            style: const TextStyle(
                              fontFamily: 'inter',
                              fontSize: 14,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: isSaving
                                  ? null
                                  : () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'inter',
                                  color: Color(0xFF999999),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isSaving ? null : _saveOutfit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6B5344),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isSaving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Save',
                                      style: TextStyle(
                                        fontFamily: 'inter',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
