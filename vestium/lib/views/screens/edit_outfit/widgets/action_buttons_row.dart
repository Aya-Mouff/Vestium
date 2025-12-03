import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../cubit/edit_outfit_cubit.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({super.key});

  void _saveChanges(BuildContext context) {
    final cubit = context.read<EditOutfitCubit>();
    final state = cubit.state;

    if (!state.isValid) {
      if (state.name.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter an outfit name'),
            backgroundColor: Color(0xFF795548),
          ),
        );
        return;
      }

      if (state.selectedCategory == null || state.selectedCategory!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a category'),
            backgroundColor: Color(0xFF795548),
          ),
        );
        return;
      }
    }

    // Save changes to database/storage
    // For now, just show success and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Outfit updated successfully!'),
        backgroundColor: Color(0xFF795548),
      ),
    );

    // Navigate back to outfit details
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Cancel Button
        Expanded(
          child: TextButton(
            onPressed: () => context.router.maybePop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w200,
                color: Color(0xFF3E2723),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Save Changes Button
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () => _saveChanges(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF795548),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w200,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}