import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import '../cubit/edit_item_cubit.dart';

class EditItemHeader extends StatelessWidget {
  final String imagePath;
  final Future<void> Function()? onSave;

  const EditItemHeader({
    super.key,
    required this.imagePath,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // Get the cubit here at the top level
    final cubit = context.read<EditItemCubit>();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF795548).withAlpha((0.1 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocBuilder<EditItemCubit, EditItemState>(
        builder: (context, state) {
          return Row(
            children: [
              _BackButton(imagePath: imagePath, cubit: cubit),
              const _Title(),
              _SaveButton(
                imagePath: imagePath,
                onSave: onSave,
                state: state,
                cubit: cubit,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final String imagePath;
  final EditItemCubit cubit;

  const _BackButton({
    required this.imagePath,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemCubit, EditItemState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.isRemovingBg) {
              // Cancel remove bg mode
              cubit.cancelRemoveBg();
            } else {
              // Go back to previous screen
              context.router.maybePop();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5ECE7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.close,
              color: Color(0xFF3E2723),
              size: 24,
            ),
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
    return BlocBuilder<EditItemCubit, EditItemState>(
      builder: (context, state) {
        return Expanded(
          child: Text(
            state.isRemovingBg ? 'Remove Background' : 'Edit Item',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF3E2723),
              letterSpacing: 0.2,
            ),
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  final String imagePath;
  final Future<void> Function()? onSave;
  final EditItemState state;
  final EditItemCubit cubit;

  const _SaveButton({
    required this.imagePath,
    this.onSave,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _saveAndContinue(context),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF795548),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _saveAndContinue(BuildContext context) async {
    print('🎯 _saveAndContinue called, isRemovingBg: ${state.isRemovingBg}');
    
    if (state.isRemovingBg) {
      try {
        print('💾 About to call onSave');
        // Save the edited image first
        if (onSave != null) {
          await onSave!();
          print('✅ onSave completed');
        } else {
          print('⚠️ onSave is null');
        }
        
        print('🔄 Canceling remove BG mode');
        // Exit eraser mode and go back to edit buttons
        cubit.cancelRemoveBg();
        
        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Background removed successfully',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF795548),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        print('✅ Snackbar shown');
      } catch (e, stackTrace) {
        print('❌ Error in _saveAndContinue: $e');
        print('Stack trace: $stackTrace');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Proceed to next screen with the current image
      final finalImagePath = state.editedImagePath ?? imagePath;
      print('📤 Proceeding to ItemDetails with path: $finalImagePath');
      context.router.push(ItemDetailsRoute(imagePath: finalImagePath));
    }
  }
}