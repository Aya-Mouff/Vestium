// lib/wardrobe_screen/widgets/filter_chips_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/wardrobe_cubit.dart';
import '../cubit/wardrobe_state.dart';

class FilterChipsWidget extends StatelessWidget {
  const FilterChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<WardrobeCubit, WardrobeState>(
      builder: (context, state) {
        if (state.categories.isEmpty && !state.isLoading) {
          return const SizedBox(height: 50);
        }

        // Create filters: "All" + categories
        final filters = <Map<String, dynamic>>[
          {'label': loc.wardrobeAll, 'icon': null},
          ...state.categories.map(
            (category) => {'label': category.categoryName, 'icon': null, 'id': category.categoryId},
          ),
        ];

        return SizedBox(
          height: 50,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (_, i) {
              final f = filters[i];
              final label = f['label'] as String?;
              final isSelected = state.selectedFilter == label;
              final isLoading = state.isLoading && isSelected;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                          context.read<WardrobeCubit>().changeFilter(label!);
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF8B6B61) : const Color(0xFFF0E4DC),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        else ...[
                          if (isSelected)
                            const Icon(Icons.check, size: 16, color: Colors.white)
                          else
                            const SizedBox(width: 4),
                          const SizedBox(width: 4),
                          Text(
                            label!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : const Color(0xFF8B6B61),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
