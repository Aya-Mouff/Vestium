import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../cubit/edit_outfit_cubit.dart';
import '../cubit/edit_outfit_state.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/databases/services/current_user_service.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({super.key});

  Future<void> _saveChanges(BuildContext context) async {
    final cubit = context.read<EditOutfitCubit>();
    final state = cubit.state;

    // Validate name
    if (state.name.trim().isEmpty) {
      if (context.mounted) {
        _showCustomSnackBar(
          context,
          'Please enter an outfit name',
          const Color(0xFF795548),
        );
      }
      return;
    }

    // Validate categories
    if (state.selectedCategories.isEmpty) {
      if (context.mounted) {
        _showCustomSnackBar(
          context,
          'Please select at least one category',
          const Color(0xFF795548),
        );
      }
      return;
    }

    try {
      // Save changes to database
      await cubit.saveOutfit();

      // Show success message
      if (context.mounted) {
        _showCustomSnackBar(
          context,
          'Outfit updated successfully!',
          const Color(0xFF795548),
        );
      }

      // Navigate back after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        context.router.maybePop();
      }
    } catch (e) {
      if (context.mounted) {
        _showCustomSnackBar(
          context,
          'Error saving outfit: ${e.toString()}',
          Colors.red,
        );
      }
    }
  }

  void _showCustomSnackBar(BuildContext context, String message, Color color) {
    // Check if context is still mounted before showing snackbar
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _checkAndShowDeleteDialog(BuildContext context) async {
    final cubit = context.read<EditOutfitCubit>();

    // Check if outfit can be deleted (has no posts)
    final canDelete = await cubit.canDeleteOutfit();
    final postCount = await cubit.getPostCount();

    if (!context.mounted) return;

    if (!canDelete) {
      // Show dialog that outfit cannot be deleted because it has posts
      await _showCannotDeleteDialog(context, postCount);
    } else {
      // Show delete confirmation dialog
      await _showDeleteConfirmation(context);
    }
  }

  Future<void> _showCannotDeleteDialog(
    BuildContext context,
    int postCount,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        final postText = postCount == 1 ? 'post' : 'posts';
        final oneText = postCount == 1 ? 'one' : 'ones';

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE9D9CF), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Cannot Delete Outfit',
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 16),

                // Content
                Text(
                  'This outfit is used in $postCount $postText.',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF3E2723),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'To delete this outfit, you must first delete the $postText that use it.',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF3E2723),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Warning box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFB74D),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: const Color(0xFFF57C00).withValues(alpha: .8),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Go to your posts and delete the $oneText using this outfit first.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: const Color(
                              0xFFF57C00,
                            ).withValues(alpha: .9),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     // Cancel Button
                //     TextButton(
                //       onPressed: () => Navigator.of(dialogContext).pop(),
                //       style: TextButton.styleFrom(
                //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //       ),
                //       child: const Text(
                //         'Cancel',
                //         style: TextStyle(
                //           fontFamily: 'Inter',
                //           fontSize: 14,
                //           fontWeight: FontWeight.w300,
                //           color: Color(0xFF795548),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 12),

                //     // Go to Posts Button - Use original context
                //     ElevatedButton(
                //       onPressed: () {
                //         Navigator.of(dialogContext).pop();
                //         if (context.mounted) {
                //           _navigateToPosts(context);
                //         }
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color(0xFF795548),
                //         foregroundColor: Colors.white,
                //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         elevation: 0,
                //       ),
                //       child: const Text(
                //         'Go to Posts',
                //         style: TextStyle(
                //           fontFamily: 'Inter',
                //           fontSize: 14,
                //           fontWeight: FontWeight.w300,
                //           letterSpacing: 0.2,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    Flexible(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ), // Reduced padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF795548),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Reduced spacing
                    // Go to Posts Button - Use original context
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          if (context.mounted) {
                            _navigateToPosts(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF795548),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ), // Reduced padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Go to Posts',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _navigateToPosts(BuildContext context) {
  //   // Implement navigation to user's posts screen
  //   // You can use context.router.push() to navigate to posts screen
  //   if (!context.mounted) return;

  //   _showCustomSnackBar(
  //     context,
  //     'Navigate to posts screen to manage posts',
  //     const Color(0xFF795548),
  //   );

  // }

  void _navigateToPosts(BuildContext context) {
    if (!context.mounted) return;

    // Get current user ID directly from CurrentUserService
    final userId = CurrentUserService.currentUserId;

    if (userId == null) {
      // User is not logged in
      _showCustomSnackBar(
        context,
        'Please log in to view your profile',
        const Color(0xFF795548),
      );
      return;
    }

    // Navigate to MyProfileRoute with the user ID
    context.router.push(MyProfileRoute(userId: userId));
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final cubit = context.read<EditOutfitCubit>();
    final outfitName = cubit.state.name;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE9D9CF), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Delete Outfit',
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 16),

                // Content
                Text(
                  'Are you sure you want to delete "$outfitName"?',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF3E2723),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'This action cannot be undone.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF795548),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Delete Button - Use original context, not dialogContext
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        if (context.mounted) {
                          await _deleteOutfit(context, cubit);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteOutfit(
    BuildContext context,
    EditOutfitCubit cubit,
  ) async {
    try {
      print('🗑️ Starting outfit deletion from UI...');

      // Show loading indicator
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Deleting outfit...',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 5),
        ),
      );

      // Call the delete function
      await cubit.deleteOutfit();

      print('✅ Outfit deletion completed in UI');

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showCustomSnackBar(
          context,
          'Outfit deleted successfully!',
          Colors.green,
        );
      }

      // Navigate back after deletion
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        print('🔙 Navigating back after deletion');
        context.router.maybePop();
      }
    } catch (e, stackTrace) {
      print('❌ Error in _deleteOutfit UI: $e');
      print('Stack trace: $stackTrace');

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showCustomSnackBar(
          context,
          'Error deleting outfit: ${e.toString()}',
          Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Warning message if outfit has posts
        BlocBuilder<EditOutfitCubit, EditOutfitState>(
          builder: (context, state) {
            final postCount = state.outfit?['postCount'] ?? 0;
            final hasPosts = state.outfit?['hasPosts'] ?? false;

            if (hasPosts) {
              final postText = postCount == 1 ? 'post' : 'posts';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFB74D), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: const Color(0xFFF57C00).withValues(alpha: .8),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This outfit is used in $postCount $postText',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(
                                0xFFF57C00,
                              ).withValues(alpha: .9),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Delete the $postText first to delete this outfit',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: const Color(
                                0xFFF57C00,
                              ).withValues(alpha: .8),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Delete button (red)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.red.withValues(alpha: .3),
              width: 1,
            ),
            color: Colors.red.withValues(alpha: .05),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _checkAndShowDeleteDialog(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.red.withValues(alpha: .9),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Delete Outfit',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.red,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Save and Cancel buttons
        Row(
          children: [
            // Cancel Button
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD7CCC8), width: 1),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.router.maybePop(),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF795548),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Save Changes Button
            Expanded(
              flex: 2,
              child: BlocBuilder<EditOutfitCubit, EditOutfitState>(
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF795548).withValues(alpha: .2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: state.isLoading
                          ? const Color(0xFF795548).withValues(alpha: .5)
                          : const Color(0xFF795548),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: state.isLoading
                            ? null
                            : () => _saveChanges(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
