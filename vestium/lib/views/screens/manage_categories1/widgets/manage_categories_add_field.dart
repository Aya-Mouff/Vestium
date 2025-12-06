import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/manage_categories_cubit.dart';
import '../cubit/manage_categories_state.dart';

class ManageCategoriesAddField extends StatefulWidget {
  const ManageCategoriesAddField({super.key});

  @override
  State<ManageCategoriesAddField> createState() =>
      _ManageCategoriesAddFieldState();
}

class _ManageCategoriesAddFieldState extends State<ManageCategoriesAddField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<ManageCategoriesCubit>().state;
    _controller.text = state.newCategoryName;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ManageCategoriesCubit, ManageCategoriesState>(
      listenWhen: (previous, current) =>
          previous.newCategoryName != current.newCategoryName,
      listener: (context, state) {
        if (_controller.text != state.newCategoryName) {
          _controller.text = state.newCategoryName;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }
      },
      child: Padding(
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
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
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
                  onChanged: (value) => context
                      .read<ManageCategoriesCubit>()
                      .newCategoryNameChanged(value),
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
                onPressed: () =>
                    context.read<ManageCategoriesCubit>().addCategory(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
