import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_item_cubit.dart';

class EditButtons extends StatelessWidget {
  const EditButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: _CropButton()),
            const SizedBox(width: 12),
            const Expanded(child: _RemoveBgButton()),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _CropButton extends StatelessWidget {
  const _CropButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemCubit, EditItemState>(
      builder: (context, state) {
        return ElevatedButton.icon(
          onPressed: state.isCropping ? null : () => _cropImage(context), // FIXED: Pass context
          icon: const Icon(Icons.crop_rotate, size: 20),
          label: const Text(
            'Crop',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w200,
              letterSpacing: 0.2,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD7CCC8),
            foregroundColor: const Color(0xFF795548),
            disabledBackgroundColor: const Color(0xFFD7CCC8).withAlpha(128),
            disabledForegroundColor: const Color(0xFF795548).withAlpha(128),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        );
      },
    );
  }

  void _cropImage(BuildContext context) { // FIXED: Added context parameter
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Crop functionality - Coming soon'),
        backgroundColor: Color(0xFF795548),
      ),
    );
  }
}

class _RemoveBgButton extends StatelessWidget {
  const _RemoveBgButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemCubit, EditItemState>(
      builder: (context, state) {
        return ElevatedButton.icon(
          onPressed: state.isCropping ? null : () => _removeBackground(context), // FIXED: Pass context
          icon: const Icon(Icons.auto_fix_high, size: 20),
          label: const Text(
            'Remove BG',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w200,
              letterSpacing: 0.2,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF795548),
            foregroundColor: const Color(0xFFFFFFFF),
            disabledBackgroundColor: const Color(0xFF795548).withAlpha(128),   // 0.5 * 255
            disabledForegroundColor: const Color(0xFFFFFFFF).withAlpha(179),  // 0.7 * 255
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        );
      },
    );
  }

  void _removeBackground(BuildContext context) { // FIXED: Added context parameter
    context.read<EditItemCubit>().startRemovingBg();
  }
}