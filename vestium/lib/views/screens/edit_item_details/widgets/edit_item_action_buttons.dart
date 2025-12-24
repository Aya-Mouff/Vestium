// lib/edit_item_details_screen/widgets/edit_item_action_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../cubit/edit_item_details_cubit.dart';
import '../cubit/edit_item_details_state.dart';

class EditItemActionButtons extends StatelessWidget {
  const EditItemActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditItemDetailsCubit, EditItemDetailsState>(
      listener: (context, state) {
        // Handle successful save
        if (state.itemSaved && state.item != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item updated successfully!'),
              backgroundColor: Color(0xFF795548),
              duration: Duration(seconds: 2),
            ),
          );

          Future.delayed(const Duration(milliseconds: 1500), () {
            if (context.mounted) {
              context.router.maybePop(true);
            }
          });
        }

        // Handle successful deletion
        if (state.itemDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item deleted successfully!'),
              backgroundColor: Color(0xFF795548),
              duration: Duration(seconds: 2),
            ),
          );

          Future.delayed(const Duration(milliseconds: 1500), () {
            if (context.mounted) {
              context.router.maybePop(true);
            }
          });
        }

        // Handle errors
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<EditItemDetailsCubit>().clearError();
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isSubmitting || !state.isValid
                      ? null
                      : () {
                          if (!state.isValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter item name and select at least one category',
                                ),
                                backgroundColor: Color(0xFF795548),
                              ),
                            );
                            return;
                          }
                          context.read<EditItemDetailsCubit>().saveItem();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
                    foregroundColor: const Color(0xFFFFFFFF),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFFFFFF),
                          ),
                        )
                      : const Text(
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

              const SizedBox(height: 16),

              // Delete button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: state.isDeleting
                      ? null
                      : () => _showDeleteConfirmation(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF795548), width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: state.isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF795548),
                          ),
                        )
                      : const Text(
                          'Delete Item',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            color: Color(0xFF795548),
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    // Store context locally before async gap
    final localContext = context;

    final result = await showDialog<bool>(
      context: localContext,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text(
          'Delete Item',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 18,
            color: Color(0xFF3E2723),
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this item?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFF3E2723),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Inter', color: Color(0xFF795548)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(fontFamily: 'Inter', color: Colors.red),
            ),
          ),
        ],
      ),
    );

    // Check if widget is still mounted before using context
    if (result == true && localContext.mounted) {
      final cubit = localContext.read<EditItemDetailsCubit>();
      final deleteResult = await cubit.deleteItem();

      if (deleteResult.isBlocked &&
          deleteResult.blockingOutfits != null &&
          localContext.mounted) {
        _showBlockedDialog(localContext, deleteResult.blockingOutfits!);
      }
    }
  }

  void _showBlockedDialog(
    BuildContext context,
    List<Map<String, dynamic>> outfitDetails,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text(
          'Cannot Delete Item',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 18,
            color: Color(0xFF3E2723),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This item is used in the following outfits:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 12),
            ...outfitDetails.map(
              (outfit) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '• ${outfit['display']}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Color(0xFF795548),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Remove the item from these outfits first.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Color(0xFF795548),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: 'Inter', color: Color(0xFF795548)),
            ),
          ),
        ],
      ),
    );
  }
}
