// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:auto_route/auto_route.dart';
// import '../cubit/item_details_cubit.dart';

// class AddToWardrobeButton extends StatelessWidget {
//   const AddToWardrobeButton({super.key});

//   void _addToWardrobe(BuildContext context) {
//     final cubit = context.read<ItemDetailsCubit>();
//     final state = cubit.state;

//     if (!state.isValid) {
//       if (state.name.trim().isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please enter an item name'),
//             backgroundColor: Color(0xFF795548),
//           ),
//         );
//         return;
//       }

//       if (state.selectedCategories.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please select at least one category'),
//             backgroundColor: Color(0xFF795548),
//           ),
//         );
//         return;
//       }
//     }

//     // Save to database/storage
//     // For now, just show success and navigate back
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Item added to wardrobe!'),
//         backgroundColor: Color(0xFF795548),
//       ),
//     );

//     // Navigate back to home or wardrobe screen
//     context.router.popUntilRoot();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFFFFF),
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           onPressed: () => _addToWardrobe(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF795548),
//             foregroundColor: const Color(0xFFFFFFFF),
//             padding: const EdgeInsets.symmetric(vertical: 18),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 0,
//           ),
//           child: const Text(
//             'Add to Wardrobe',
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 16,
//               fontWeight: FontWeight.w200,
//               letterSpacing: 0.3,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ==========================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/databases/services/current_user_service.dart'; // Add this import
import '../cubit/item_details_cubit.dart';
import '../cubit/item_details_state.dart';

class AddToWardrobeButton extends StatelessWidget {
  const AddToWardrobeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemDetailsCubit, ItemDetailsState>(
      listener: (context, state) {
        // Listen for successful save
        if (state.itemSaved && state.item != null) {
          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item added to wardrobe!'),
                backgroundColor: Color(0xFF795548),
                duration: Duration(seconds: 2),
              ),
            );

            // Navigate back to home or wardrobe screen after delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                final userId = CurrentUserService.currentUserId;
                
                if (userId != null) {
                  // Replace current stack with WardrobeRoute
                  context.router.replace(
                    WardrobeRoute(userId: userId),
                  );
                } else {
                  // Fallback: pop to root
                  print('⚠️ No user logged in, popping to root');
                  context.router.popUntilRoot();
                }
              }
            });
          }
        }

        // Listen for errors
        if (state.errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<ItemDetailsCubit>().clearError();
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isSubmitting ? null : () {
                final cubit = context.read<ItemDetailsCubit>();
                
                // Validate first
                if (!state.isValid) {
                  if (state.name.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter an item name'),
                        backgroundColor: Color(0xFF795548),
                      ),
                    );
                    return;
                  }

                  if (state.selectedCategories.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select at least one category'),
                        backgroundColor: Color(0xFF795548),
                      ),
                    );
                    return;
                  }
                }
                
                // Save to database
                cubit.saveItem();
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
                      'Add to Wardrobe',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}