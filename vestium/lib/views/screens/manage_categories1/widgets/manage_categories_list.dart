import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/manage_categories_cubit.dart';
import '../cubit/manage_categories_state.dart';

class ManageCategoriesList extends StatelessWidget {
  const ManageCategoriesList({super.key});

  void _showEditDialog(BuildContext context, int index, String currentName) {
    final controller = TextEditingController(text: currentName);

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
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context
                    .read<ManageCategoriesCubit>()
                    .editCategory(index, controller.text);
              }
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

  void _showDeleteDialog(BuildContext context, int index, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Category',
          style: TextStyle(fontFamily: 'Inter', color: Colors.black),
        ),
        content: Text(
          'Are you sure you want to delete "$name"?',
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
            onPressed: () {
              context.read<ManageCategoriesCubit>().deleteCategory(index);
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ManageCategoriesCubit, ManageCategoriesState>(
        builder: (context, state) {
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
                      onPressed: () =>
                          _showEditDialog(context, index, category.name),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: Colors.red[400],
                      onPressed: () =>
                          _showDeleteDialog(context, index, category.name),
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
}
