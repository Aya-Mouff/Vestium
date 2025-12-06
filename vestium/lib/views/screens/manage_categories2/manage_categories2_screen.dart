import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/manage_categories2_cubit.dart';
import 'widgets/manage_categories2_app_bar.dart';
import 'widgets/manage_categories2_add_field.dart';
import 'widgets/manage_categories2_list.dart';
import 'widgets/manage_categories2_bottom_text.dart';

@RoutePage()
class ManageCategoriesScreen2 extends StatelessWidget {
  final int userId;

  const ManageCategoriesScreen2({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageCategories2Cubit(userId: userId),
      child: const _ManageCategories2View(),
    );
  }
}

class _ManageCategories2View extends StatelessWidget {
  const _ManageCategories2View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      appBar: const ManageCategories2AppBar(),
      body: Column(
        children: const [
          ManageCategories2AddField(),
          ManageCategories2List(),
          ManageCategories2BottomText(),
        ],
      ),
    );
  }
}
