// manage_categories/widgets/categories_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/manage_categories_cubit.dart';
import '../cubit/manage_categories_state.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ManageCategoriesCubit, ManageCategoriesState>(
        builder: (context, state) {
          if (state.isLoading && state.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${category.itemCount} items',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF795548),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      color: const Color(0xFF795548),
                      onPressed: () => _showEditDialog(context, index),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: Colors.red[400],
                      onPressed: () => _showDeleteDialog(context, index),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    final cubit = context.read<ManageCategoriesCubit>();
    final category = cubit.state.categories[index];
    final controller = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Category',
          style: TextStyle(fontFamily: 'Inter', color: Colors.black),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(fontFamily: 'Inter', color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Category name',
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF795548),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF795548),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await cubit.editCategory(index, controller.text);
              }
              // ignore result errors for UI simplicity
              // (you could show Snackbar if state.errorMessage != null)
              // after editing, close dialog
              // (the list will rebuild via BlocBuilder)
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF795548),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    final cubit = context.read<ManageCategoriesCubit>();
    final category = cubit.state.categories[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Category',
          style: TextStyle(fontFamily: 'Inter', color: Colors.black),
        ),
        content: Text(
          'Are you sure you want to delete "${category.name}"?',
          style: const TextStyle(fontFamily: 'Inter', color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF795548),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await cubit.deleteCategory(index);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
