// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/item_details_cubit.dart';
// import '../cubit/item_details_state.dart';

// class CategoriesSelection extends StatelessWidget {
//   final List<String> categories = [
//     'Tops',
//     'Bottoms',
//     'Dresses',
//     'Outerwear',
//     'Shoes',
//     'Accessories',
//   ];

//   CategoriesSelection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Categories',
//           style: TextStyle(
//             fontFamily: 'CormorantGaramond',
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: Color(0xFF3E2723),
//             letterSpacing: 0.2,
//           ),
//         ),
//         const SizedBox(height: 12),
//         BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
//           builder: (context, state) {
//             return Wrap(
//               spacing: 10,
//               runSpacing: 10,
//               children: categories.map((category) {
//                 final isSelected = state.selectedCategories.contains(category);
//                 return GestureDetector(
//                   onTap: () {
//                     context.read<ItemDetailsCubit>().toggleCategory(category);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? const Color(0xFF795548)
//                           : const Color(0xFFFFFFFF),
//                       borderRadius: BorderRadius.circular(24),
//                       border: Border.all(
//                         color: isSelected
//                             ? const Color(0xFF795548)
//                             : const Color(0xFFD7CCC8),
//                         width: 1,
//                       ),
//                     ),
//                     child: Text(
//                       category,
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w200,
//                         color: isSelected
//                             ? const Color(0xFFFFFFFF)
//                             : const Color(0xFF795548),
//                         letterSpacing: 0.2,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// ===============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/item_details_cubit.dart';
import '../cubit/item_details_state.dart';
import 'package:vestium/repo/item_category_repo.dart';
import 'package:vestium/databases/db_models.dart';

class CategoriesSelection extends StatefulWidget {
  const CategoriesSelection({super.key});

  @override
  State<CategoriesSelection> createState() => _CategoriesSelectionState();
}

class _CategoriesSelectionState extends State<CategoriesSelection> {
  late Future<List<ItemCategory>> _categoriesFuture;
  final ItemCategoryRepo _categoryRepo = ItemCategoryRepo();

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<ItemCategory>> _fetchCategories() async {
    try {
      // Fetch categories from database
      final categories = await _categoryRepo.getAll();
      
      // If no categories in database, return initial categories
      if (categories.isEmpty) {
        return await _categoryRepo.getInitialCategories();
      }
      
      return categories;
    } catch (e) {
      print('❌ Error fetching categories: $e');
      // Return initial categories as fallback
      return await _categoryRepo.getInitialCategories();
    }
  }

  void _refreshCategories() {
    setState(() {
      _categoriesFuture = _fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemCategory>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final categories = snapshot.data!;
        return _buildCategoriesList(categories, context);
      },
    );
  }

  Widget _buildLoadingState() {
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF795548),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Loading categories...',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xFF795548),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5ECE7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD7CCC8)),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFF795548),
                size: 32,
              ),
              const SizedBox(height: 8),
              const Text(
                'Failed to load categories',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xFF795548),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _refreshCategories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF795548),
                  foregroundColor: const Color(0xFFFFFFFF),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5ECE7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD7CCC8)),
          ),
          child: const Center(
            child: Text(
              'No categories found. Add some in Settings.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Color(0xFF795548),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesList(List<ItemCategory> categories, BuildContext context) {
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
        BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
          builder: (context, state) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((category) {
                final isSelected = state.selectedCategories.contains(category.categoryName ?? '');
                return GestureDetector(
                  onTap: () {
                    if (category.categoryName != null) {
                      context.read<ItemDetailsCubit>().toggleCategory(category.categoryName!);
                    }
                  },
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
                      category.categoryName ?? 'Unknown',
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
            );
          },
        ),
      ],
    );
  }
}