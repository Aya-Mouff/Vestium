// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/save_outfit_cubit.dart';
// import '../cubit/save_outfit_state.dart';

// class CategorySelector extends StatelessWidget {
//   const CategorySelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
//       builder: (context, state) {
//         if (state is! SaveOutfitDataLoaded) {
//           return const SizedBox();
//         }

//         final isEnabled = !state.isSaving;
//         final categories = state.allCategories;
//         final selectedIds = state.selectedCategoryIds;

//         return Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: categories.map((category) {
//             final isSelected = selectedIds.contains(category.categoryId);
//             return GestureDetector(
//               onTap: isEnabled
//                   ? () => context.read<SaveOutfitCubit>().toggleCategory(category.categoryId!)
//                   : null,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSelected 
//                       ? const Color(0xFF795548)
//                       : const Color(0xFFF5ECE7),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: isSelected 
//                         ? const Color(0xFF795548)
//                         : const Color(0xFFA1887F),
//                     width: 1,
//                   ),
//                 ),
//                 child: Text(
//                   category.categoryName ?? '',
//                   style: TextStyle(
//                     fontFamily: 'CormorantGaramond',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: isSelected 
//                         ? Colors.white
//                         : const Color(0xFF3E2723),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
// ===========================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/save_outfit_cubit.dart';
import '../cubit/save_outfit_state.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
      builder: (context, state) {
        if (state is! SaveOutfitDataLoaded) {
          return const SizedBox();
        }

        final isEnabled = !state.isSaving;
        final categories = state.allCategories;
        final selectedIds = state.selectedCategoryIds;

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
              spacing: 10,
              runSpacing: 10,
              children: categories.map((category) {
                final isSelected = selectedIds.contains(category.categoryId);
                return GestureDetector(
                  onTap: isEnabled
                      ? () => context.read<SaveOutfitCubit>().toggleCategory(category.categoryId!)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFF795548)
                          : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFF795548)
                            : const Color(0xFFD7CCC8),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      category.categoryName ?? '',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: isSelected 
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF795548),
                        letterSpacing: 0.2,
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