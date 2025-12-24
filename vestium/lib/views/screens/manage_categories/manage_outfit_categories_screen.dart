import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/manage_outfit_categories_cubit.dart';
import 'widgets/add_outfit_category_row.dart';
import 'widgets/outfit_categories_list.dart';
import 'widgets/bottom_info_text.dart';
import '../../../databases/services/outfit_category_service.dart';

@RoutePage()
class ManageOutfitCategoriesScreen extends StatelessWidget {
  final int userId; // keep for router compatibility
  const ManageOutfitCategoriesScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageOutfitCategoriesCubit(OutfitCategoryService())
        ..loadCategories(),
      child: const _ManageOutfitCategoriesView(),
    );
  }
}

class _ManageOutfitCategoriesView extends StatelessWidget {
  const _ManageOutfitCategoriesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Manage Categories For Outfits',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'CormorantGaramond',
          ),
        ),
      ),
      body: const Column(
        children: [
          AddOutfitCategoryRow(),
          OutfitCategoriesList(),
          BottomInfoText(),
        ],
      ),
    );
  }
}
