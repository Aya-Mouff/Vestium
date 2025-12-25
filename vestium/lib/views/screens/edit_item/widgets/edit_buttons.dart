import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
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
        final loc = AppLocalizations.of(context)!;
        final isCropping = state.isCropping;
        return ElevatedButton.icon(
          onPressed: () => _handleCropPressed(context, isCropping),
          icon: Icon(isCropping ? Icons.check : Icons.crop_rotate, size: 20),
          label: Text(
            isCropping ? loc.editItemDoneButton : loc.editItemCropButton,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w200, letterSpacing: 0.2),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isCropping ? const Color(0xFF795548) : const Color(0xFFD7CCC8),
            foregroundColor: isCropping ? const Color(0xFFFFFFFF) : const Color(0xFF795548),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
        );
      },
    );
  }

  void _handleCropPressed(BuildContext context, bool isCropping) {
    final cubit = context.read<EditItemCubit>();
    if (isCropping) {
      // Exit crop mode - save the crop first
      print('🔍 Crop Done button pressed - saving crop');
      // The parent widget (EditItemScreen) will handle the save
      // Just stop cropping mode, the save button will handle confirmEdits()
      cubit.stopCropping();
    } else {
      // Enter crop mode - cancel remove BG first
      print('🔍 Crop button pressed - entering crop mode');
      cubit.cancelRemoveBg();
      cubit.startCropping();
    }
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
          label: Builder(
            builder: (context) {
              final loc = AppLocalizations.of(context)!;
              return Text(
                loc.editItemRemoveBgButton,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 0.2,
                ),
              );
            },
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF795548),
            foregroundColor: const Color(0xFFFFFFFF),
            disabledBackgroundColor: const Color(0xFF795548).withAlpha(128), // 0.5 * 255
            disabledForegroundColor: const Color(0xFFFFFFFF).withAlpha(179), // 0.7 * 255
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
        );
      },
    );
  }

  void _removeBackground(BuildContext context) {
    final cubit = context.read<EditItemCubit>();
    // Ensure crop mode is stopped first
    if (cubit.state.isCropping) {
      cubit.stopCropping();
    }
    cubit.startRemovingBg();
  }
}
