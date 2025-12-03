import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import '../cubit/edit_item_cubit.dart';

class EditItemHeader extends StatelessWidget {
  final String imagePath;

  const EditItemHeader({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _BackButton(imagePath: imagePath),
          const _Title(),
          _SaveButton(imagePath: imagePath),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final String imagePath;

  const _BackButton({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemCubit, EditItemState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.isRemovingBg) {
              context.read<EditItemCubit>().cancelRemoveBg();
            } else {
              context.router.maybePop(); // FIXED: Using context.router
            }
          },
          child: const Icon(
            Icons.close,
            color: Color(0xFF3E2723),
            size: 24,
          ),
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Text(
        'Edit Item',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'CormorantGaramond',
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Color(0xFF3E2723),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final String imagePath;

  const _SaveButton({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemCubit, EditItemState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _saveAndContinue(context, state),
          child: const Icon(
            Icons.check,
            color: Color(0xFF3E2723),
            size: 24,
          ),
        );
      },
    );
  }

  void _saveAndContinue(BuildContext context, EditItemState state) {
    if (state.isRemovingBg) {
      context.read<EditItemCubit>().cancelRemoveBg();
    } else {
      // FIXED: Using proper router navigation
      context.router.push(ItemDetailsRoute(imagePath: imagePath));
    }
  }
}