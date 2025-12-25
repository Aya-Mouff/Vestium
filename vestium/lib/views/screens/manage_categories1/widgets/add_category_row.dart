// manage_categories/widgets/add_category_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/manage_categories_cubit.dart';
import '../cubit/manage_categories_state.dart';

class AddCategoryRow extends StatefulWidget {
  const AddCategoryRow({super.key});

  @override
  State<AddCategoryRow> createState() => _AddCategoryRowState();
}

class _AddCategoryRowState extends State<AddCategoryRow> {
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<ManageCategoriesCubit>().state;
    _controller.text = state.newCategoryName;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocListener<ManageCategoriesCubit, ManageCategoriesState>(
      listenWhen: (p, c) => p.newCategoryName != c.newCategoryName,
      listener: (context, state) {
        if (_controller.text != state.newCategoryName) {
          _controller.text = state.newCategoryName;
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(color: const Color(0xFFE8DCD3), borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: _controller,
                  onChanged: (value) => context.read<ManageCategoriesCubit>().onNewCategoryNameChanged(value),
                  style: const TextStyle(fontFamily: 'Inter', color: Colors.black),
                  decoration: InputDecoration(
                    hintText: loc.manageCategoriesNewHint,
                    hintStyle: TextStyle(color: Color(0xFF795548), fontSize: 14, fontFamily: 'Inter'),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: Color(0xFF795548), shape: BoxShape.circle),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add, color: Colors.white, size: 22),
                onPressed: () => context.read<ManageCategoriesCubit>().addCategory(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
