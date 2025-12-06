import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app_router.dart';
import 'cubit/manage_categories_cubit.dart';
import 'widgets/manage_categories_app_bar.dart';
import 'widgets/manage_categories_add_field.dart';
import 'widgets/manage_categories_list.dart';
import 'widgets/manage_categories_bottom_text.dart';

@RoutePage()
class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageCategoriesCubit(),
      child: const _ManageCategoriesView(),
    );
  }
}

class _ManageCategoriesView extends StatelessWidget {
  const _ManageCategoriesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      appBar: const ManageCategoriesAppBar(),
      body: Column(
        children: const [
          ManageCategoriesAddField(),
          ManageCategoriesList(),
          ManageCategoriesBottomText(),
        ],
      ),
    );
  }
}
