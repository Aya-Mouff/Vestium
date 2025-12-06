// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/edit_outfit_cubit.dart';
// import '../cubit/edit_outfit_state.dart';

// class CategoryDropdown extends StatelessWidget {
//   const CategoryDropdown({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Category',
//           style: TextStyle(
//             fontFamily: 'CormorantGaramond',
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: Color(0xFF3E2723),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFFF5ECE7),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: BlocBuilder<EditOutfitCubit, EditOutfitState>(
//             builder: (context, state) {
//               return DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: state.selectedCategory,
//                   hint: Text(
//                     'Select category',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 15,
//                       fontWeight: FontWeight.w200,
//                       color: const Color(0xFF795548).withValues(alpha: .5),
//                     ),
//                   ),
//                   isExpanded: true,
//                   icon: const Icon(
//                     Icons.keyboard_arrow_down,
//                     color: Color(0xFF795548),
//                   ),
//                   style: const TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 15,
//                     fontWeight: FontWeight.w200,
//                     color: Color(0xFF3E2723),
//                   ),
//                   dropdownColor: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   items: state.userCategories.map((String category) {
//                     return DropdownMenuItem<String>(
//                       value: category,
//                       child: Text(category),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     context.read<EditOutfitCubit>().updateCategory(newValue);
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// ============================================

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/edit_outfit_cubit.dart';
// import '../cubit/edit_outfit_state.dart';

// class CategoryDropdown extends StatelessWidget {
//   const CategoryDropdown({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Category',
//           style: TextStyle(
//             fontFamily: 'CormorantGaramond',
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: Color(0xFF3E2723),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFFF5ECE7),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: const Color(0xFFE9D9CF),
//               width: 1,
//             ),
//           ),
//           child: BlocBuilder<EditOutfitCubit, EditOutfitState>(
//             builder: (context, state) {
//               if (state.isLoading) {
//                 return Container(
//                   height: 56,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: const Color(0xFF795548).withValues(alpha: .6),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         'Loading categories...',
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 14,
//                           fontWeight: FontWeight.w300,
//                           color: const Color(0xFF795548).withValues(alpha: .6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
              
//               final categories = state.userCategories;
              
//               return DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: state.selectedCategory,
//                   hint: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'Select category',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 15,
//                         fontWeight: FontWeight.w300,
//                         color: const Color(0xFF795548).withValues(alpha: .5),
//                       ),
//                     ),
//                   ),
//                   isExpanded: true,
//                   icon: Container(
//                     padding: const EdgeInsets.only(right: 16),
//                     child: Icon(
//                       Icons.keyboard_arrow_down_rounded,
//                       color: const Color(0xFF795548).withValues(alpha: .7),
//                       size: 20,
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 15,
//                     fontWeight: FontWeight.w300,
//                     color: const Color(0xFF3E2723),
//                   ),
//                   dropdownColor: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   menuMaxHeight: 250,
//                   elevation: 4,
//                   items: [
//                     DropdownMenuItem<String>(
//                       value: null,
//                       enabled: false,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         child: Text(
//                           'Select category',
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             fontSize: 14,
//                             fontWeight: FontWeight.w300,
//                             color: Colors.grey.shade400,
//                           ),
//                         ),
//                       ),
//                     ),
//                     ...categories.map((String category) {
//                       return DropdownMenuItem<String>(
//                         value: category,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           child: Text(
//                             category,
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               fontSize: 15,
//                               fontWeight: FontWeight.w300,
//                               color: const Color(0xFF3E2723),
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       context.read<EditOutfitCubit>().updateCategory(newValue);
//                     }
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// ========================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_outfit_cubit.dart';
import '../cubit/edit_outfit_state.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<EditOutfitCubit, EditOutfitState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5ECE7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE9D9CF),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: const Color(0xFF795548).withValues(alpha: .6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Loading categories...',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF795548).withValues(alpha: .6),
                      ),
                    ),
                  ],
                ),
              );
            }

            final categories = state.userCategories;
            final selectedCategories = state.selectedCategories;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5ECE7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE9D9CF),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedCategories.isEmpty)
                    Text(
                      'No categories selected',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF795548).withValues(alpha: .5),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        final isSelected = selectedCategories.contains(category);
                        return _CategoryChip(
                          label: category,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<EditOutfitCubit>().toggleCategory(category);
                          },
                        );
                      }).toList(),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF795548) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF795548)
                  : const Color(0xFFD7CCC8),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: isSelected ? Colors.white : const Color(0xFF3E2723),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}