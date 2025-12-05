// lib/edit_item_details_screen/widgets/edit_item_categories_selection.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_item_details_cubit.dart';
import '../cubit/edit_item_details_state.dart';

class EditItemCategoriesSelection extends StatelessWidget {
  const EditItemCategoriesSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemDetailsCubit, EditItemDetailsState>(
      buildWhen: (previous, current) =>
          previous.allCategories != current.allCategories ||
          previous.selectedCategories != current.selectedCategories,
      builder: (context, state) {
        if (state.allCategories.isEmpty && !state.isLoading) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3E2723),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.allCategories.map((category) {
                final isSelected = state.selectedCategories.contains(category);
                return GestureDetector(
                  onTap: () {
                    context.read<EditItemDetailsCubit>().toggleCategory(category);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF795548)
                          : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF795548)
                            : const Color(0xFFD7CCC8),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: isSelected
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF795548),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}