import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/save_outfit_cubit.dart';
import '../cubit/save_outfit_state.dart';
import 'package:auto_route/auto_route.dart';

class SaveButtons extends StatelessWidget {
  const SaveButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
      builder: (context, state) {
        final isSaving = state is SaveOutfitDataLoaded && state.isSaving;
        final isValid = state is SaveOutfitDataLoaded && 
                       state.outfitName.trim().isNotEmpty &&
                       state.itemsCount > 0;

        return Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: isSaving ? null : () => context.router.maybePop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFFF5ECE7),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF795548),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: isSaving || !isValid
                    ? null
                    : () async {
                        final success = await context.read<SaveOutfitCubit>().saveOutfit();
                        if (success && context.mounted) {
                          context.router.maybePop(true);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF795548),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(
                        'Save Outfit',
                        style: TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}