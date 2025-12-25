// manage_categories/manage_categories_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import 'cubit/manage_categories_cubit.dart';
import 'widgets/add_category_row.dart';
import 'widgets/categories_list.dart';
import 'widgets/bottom_info_text.dart';
import 'package:vestium/repo/item_category_repo.dart';
import 'package:vestium/repo/item_category_join_repo.dart';

@RoutePage()
class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageCategoriesCubit(ItemCategoryRepo(), ItemCategoryJoinRepo())..loadCategories(),
      child: const _ManageCategoriesView(),
    );
  }
}

class _ManageCategoriesView extends StatelessWidget {
  const _ManageCategoriesView();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            // or context.router.pop();
          },
        ),
        title: Text(
          loc.manageCategoriesTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'CormorantGaramond',
          ),
        ),
      ),
      body: Column(children: const [AddCategoryRow(), CategoriesList(), BottomInfoText()]),
    );
  }
}
