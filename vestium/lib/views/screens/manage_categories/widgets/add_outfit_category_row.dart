import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/manage_outfit_categories_cubit.dart';

class AddOutfitCategoryRow extends StatefulWidget {
  const AddOutfitCategoryRow({super.key});

  @override
  State<AddOutfitCategoryRow> createState() => _AddOutfitCategoryRowState();
}

class _AddOutfitCategoryRowState extends State<AddOutfitCategoryRow> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8DCD3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _controller,
                onChanged: (value) => context
                    .read<ManageOutfitCategoriesCubit>()
                    .onNewCategoryNameChanged(value),
                style: const TextStyle(fontFamily: 'Inter', color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'New category name...',
                  hintStyle: TextStyle(
                    color: Color(0xFF795548),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF795548),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.add, color: Colors.white, size: 22),
              onPressed: () async {
                await context
                    .read<ManageOutfitCategoriesCubit>()
                    .addCategory();
                _controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
