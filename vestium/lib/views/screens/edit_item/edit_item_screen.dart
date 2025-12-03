import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'cubit/edit_item_cubit.dart';
import 'widgets/edit_item_header.dart';
import 'widgets/photo_preview.dart';
import 'widgets/bottom_actions.dart';

@RoutePage()
class EditItemScreen extends StatefulWidget {
  final String imagePath;

  const EditItemScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<EditItemScreen> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditItemCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        body: SafeArea(
          child: Column(
            children: [
              EditItemHeader(imagePath: widget.imagePath),
              PhotoPreview(imagePath: widget.imagePath),
              const BottomActions(),
            ],
          ),
        ),
      ),
    );
  }
}