// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:auto_route/auto_route.dart';
// import './cubit/edit_outfit_cubit.dart';
// import './cubit/edit_outfit_state.dart';
// import './widgets/edit_outfit_appbar.dart';
// import './widgets/outfit_image_preview.dart';
// import './widgets/outfit_name_field.dart';
// import './widgets/outfit_description_field.dart';
// import './widgets/category_dropdown.dart';
// import './widgets/season_dropdown.dart';
// import './widgets/action_buttons_row.dart';

// @RoutePage()
// class EditOutfitScreen extends StatelessWidget {
//   final String outfitId;

//   const EditOutfitScreen({
//     super.key,
//     @PathParam('outfitId') required this.outfitId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => EditOutfitCubit(outfitId: outfitId),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5ECE7),
//         appBar: const EditOutfitAppBar(),
//         body: BlocBuilder<EditOutfitCubit, EditOutfitState>(
//           builder: (context, state) {
//             if (state.isLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   color: Color(0xFF795548),
//                 ),
//               );
//             }

//             if (state.outfit == null || state.hasError) {
//               return const Center(
//                 child: Text(
//                   'Error loading outfit data',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w200,
//                     color: Color(0xFF3E2723),
//                   ),
//                 ),
//               );
//             }

//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   OutfitImagePreview(imageUrl: state.outfit!['imageUrl']),
//                   const SizedBox(height: 16),
//                   // Edit Form
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const OutfitNameField(),
//                         const SizedBox(height: 20),
//                         const OutfitDescriptionField(),
//                         const SizedBox(height: 20),
//                         const CategoryDropdown(),
//                         const SizedBox(height: 20),
//                         SeasonDropdown(),
//                         const SizedBox(height: 32),
//                         const ActionButtonsRow(),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// ==========================================================

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:auto_route/auto_route.dart';
// import './cubit/edit_outfit_cubit.dart';
// import './cubit/edit_outfit_state.dart';
// import './widgets/edit_outfit_appbar.dart';
// import './widgets/outfit_image_preview.dart';
// import './widgets/outfit_name_field.dart';
// import './widgets/outfit_description_field.dart';
// import 'widgets/category_selector.dart';
// import './widgets/season_dropdown.dart';
// import './widgets/action_buttons_row.dart';

// @RoutePage()
// class EditOutfitScreen extends StatelessWidget {
//   final int outfitId;

//   const EditOutfitScreen({
//     super.key,
//     @PathParam('outfitId') required this.outfitId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => EditOutfitCubit(outfitId: outfitId),
//       child: const _EditOutfitScreenContent(),
//     );
//   }
// }

// class _EditOutfitScreenContent extends StatefulWidget {
//   const _EditOutfitScreenContent();

//   @override
//   State<_EditOutfitScreenContent> createState() =>
//       _EditOutfitScreenContentState();
// }

// class _EditOutfitScreenContentState extends State<_EditOutfitScreenContent> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<EditOutfitCubit, EditOutfitState>(
//       listener: (context, state) {
//         // Handle deletion - navigate back when deleted
//         if (state.isDeleted) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             context.router.maybePop();
//           });
//         }

//         // Handle errors - Cubit will clear them automatically
//         if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
//           _showCustomSnackBar(context, state.errorMessage!, Colors.red);
//         }

//         // Handle success messages - Cubit will clear them automatically
//         if (state.successMessage != null && state.successMessage!.isNotEmpty) {
//           _showCustomSnackBar(
//             context,
//             state.successMessage!,
//             const Color(0xFF795548),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5ECE7),
//         appBar: const EditOutfitAppBar(),
//         body: BlocBuilder<EditOutfitCubit, EditOutfitState>(
//           builder: (context, state) {
//             if (state.isLoading) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 40,
//                       height: 40,
//                       child: CircularProgressIndicator(
//                         color: const Color(0xFF795548),
//                         strokeWidth: 2.5,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'Loading outfit...',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w300,
//                         color: const Color(0xFF795548).withValues(alpha: .7),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             if (state.hasError) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           color: Colors.red.withValues(alpha: .1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.error_outline_rounded,
//                           size: 40,
//                           color: Colors.red.withValues(alpha: .7),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Text(
//                         'Oops! Something went wrong',
//                         style: TextStyle(
//                           fontFamily: 'CormorantGaramond',
//                           fontSize: 22,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xFF3E2723),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       if (state.errorMessage != null)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(
//                             state.errorMessage!,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               fontSize: 14,
//                               fontWeight: FontWeight.w300,
//                               color: Colors.grey.shade600,
//                               height: 1.5,
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 32),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () =>
//                                 context.read<EditOutfitCubit>().refresh(),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF795548),
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 28,
//                                 vertical: 12,
//                               ),
//                               elevation: 0,
//                             ),
//                             child: Text(
//                               'Try Again',
//                               style: TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w300,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           OutlinedButton(
//                             onPressed: () => context.router.maybePop(),
//                             style: OutlinedButton.styleFrom(
//                               side: BorderSide(
//                                 color: const Color(
//                                   0xFF795548,
//                                 ).withValues(alpha: .3),
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 28,
//                                 vertical: 12,
//                               ),
//                             ),
//                             child: Text(
//                               'Go Back',
//                               style: TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w300,
//                                 color: const Color(
//                                   0xFF795548,
//                                 ).withValues(alpha: .8),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             if (state.outfit == null) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFE9D9CF),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.search_off_rounded,
//                           size: 40,
//                           color: const Color(0xFF7B5247).withValues(alpha: .7),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Text(
//                         'Outfit not found',
//                         style: TextStyle(
//                           fontFamily: 'CormorantGaramond',
//                           fontSize: 22,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xFF3E2723),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'The outfit may have been deleted or doesn\'t exist',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 14,
//                           fontWeight: FontWeight.w300,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       ElevatedButton(
//                         onPressed: () => context.router.maybePop(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF795548),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 32,
//                             vertical: 12,
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Text(
//                           'Go Back',
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             fontSize: 14,
//                             fontWeight: FontWeight.w300,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return CustomScrollView(
//               slivers: [
//                 SliverToBoxAdapter(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Outfit image preview
//                       _buildOutfitImageSection(context, state),

//                       // Items in outfit
//                       if (state.itemCount > 0) ...[
//                         _buildItemsSection(state),
//                         const SizedBox(height: 8),
//                       ],

//                       // Edit Form Section
//                       _buildEditFormSection(context, state),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildOutfitImageSection(BuildContext context, EditOutfitState state) {
//     if (state.hasImage) {
//       return OutfitImagePreview(imageUrl: state.outfitImageUrl!);
//     }

//     return Container(
//       margin: const EdgeInsets.all(20),
//       height: 220,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: const Color(0xFFE9D9CF),
//         border: Border.all(color: const Color(0xFFD7CCC8), width: 1),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.photo_library_rounded,
//             size: 64,
//             color: const Color(0xFF7B5247).withValues(alpha: .6),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'No outfit image',
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 14,
//               fontWeight: FontWeight.w300,
//               color: const Color(0xFF7B5247).withValues(alpha: .7),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildItemsSection(EditOutfitState state) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE9D9CF), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'Items in this outfit',
//                 style: TextStyle(
//                   fontFamily: 'CormorantGaramond',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF3E2723),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5ECE7),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   state.itemCount.toString(),
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w300,
//                     color: const Color(0xFF795548),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 90,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: state.itemCount,
//               itemBuilder: (context, index) {
//                 final item = state.outfitItems[index];
//                 return Container(
//                   width: 70,
//                   margin: EdgeInsets.only(
//                     right: index == state.itemCount - 1 ? 0 : 10,
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 70,
//                         height: 70,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withValues(alpha: .05),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                           border: Border.all(
//                             color: const Color(0xFFE9D9CF),
//                             width: 1,
//                           ),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: _buildItemImage(item['imagePath']),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         item['name']?.toString().split(' ').first ?? 'Item',
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 11,
//                           fontWeight: FontWeight.w300,
//                           color: const Color(0xFF795548).withValues(alpha: .7),
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEditFormSection(BuildContext context, EditOutfitState state) {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: const Color(0xFFE9D9CF), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: .03),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Edit Outfit Details',
//             style: TextStyle(
//               fontFamily: 'CormorantGaramond',
//               fontSize: 22,
//               fontWeight: FontWeight.w500,
//               color: const Color(0xFF3E2723),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Update your outfit information',
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 13,
//               fontWeight: FontWeight.w300,
//               color: const Color(0xFF795548).withValues(alpha: .6),
//             ),
//           ),
//           const SizedBox(height: 24),
//           const OutfitNameField(),
//           const SizedBox(height: 20),
//           const OutfitDescriptionField(),
//           const SizedBox(height: 20),
//           const CategoryDropdown(),
//           const SizedBox(height: 20),
//           SeasonDropdown(),
//           const SizedBox(height: 32),
//           const ActionButtonsRow(),
//         ],
//       ),
//     );
//   }

//   Widget _buildItemImage(String? imagePath) {
//     if (imagePath == null || imagePath.isEmpty) {
//       return Container(
//         color: const Color(0xFFF5ECE7),
//         child: Center(
//           child: Icon(
//             Icons.photo_outlined,
//             color: const Color(0xFF795548).withValues(alpha: .4),
//             size: 24,
//           ),
//         ),
//       );
//     }

//     try {
//       if (imagePath.startsWith('assets/')) {
//         return Image.asset(
//           imagePath,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return _errorPlaceholder();
//           },
//         );
//       } else {
//         return Image.file(
//           File(imagePath),
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return _errorPlaceholder();
//           },
//         );
//       }
//     } catch (e) {
//       return _errorPlaceholder();
//     }
//   }

//   Widget _errorPlaceholder() {
//     return Container(
//       color: const Color(0xFFF5ECE7),
//       child: Center(
//         child: Icon(
//           Icons.broken_image_outlined,
//           color: const Color(0xFF795548).withValues(alpha: .4),
//           size: 24,
//         ),
//       ),
//     );
//   }

//   void _showCustomSnackBar(BuildContext context, String message, Color color) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 14,
//             fontWeight: FontWeight.w300,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }

// =========================================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import './cubit/edit_outfit_cubit.dart';
import './cubit/edit_outfit_state.dart';
import './widgets/edit_outfit_appbar.dart';
import './widgets/outfit_image_preview.dart';
import './widgets/outfit_name_field.dart';
import './widgets/outfit_description_field.dart';
import './widgets/category_selector.dart'; // NEW: Use selector instead of dropdown
import './widgets/season_dropdown.dart';
import './widgets/action_buttons_row.dart';

@RoutePage()
class EditOutfitScreen extends StatelessWidget {
  final int outfitId;

  const EditOutfitScreen({
    super.key,
    @PathParam('outfitId') required this.outfitId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditOutfitCubit(outfitId: outfitId),
      child: const _EditOutfitScreenContent(),
    );
  }
}

class _EditOutfitScreenContent extends StatefulWidget {
  const _EditOutfitScreenContent();

  @override
  State<_EditOutfitScreenContent> createState() =>
      _EditOutfitScreenContentState();
}

class _EditOutfitScreenContentState extends State<_EditOutfitScreenContent> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<EditOutfitCubit, EditOutfitState>(
      listener: (context, state) {
        // Handle deletion - navigate back when deleted
        if (state.isDeleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.router.maybePop();
          });
        }

        // Handle errors
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          _showCustomSnackBar(context, state.errorMessage!, Colors.red);
        }

        // Handle success messages
        if (state.successMessage != null && state.successMessage!.isNotEmpty) {
          _showCustomSnackBar(
            context,
            state.successMessage!,
            const Color(0xFF795548),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        appBar: const EditOutfitAppBar(),
        body: BlocBuilder<EditOutfitCubit, EditOutfitState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: const Color(0xFF795548),
                        strokeWidth: 2.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Loading outfit...',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF795548).withValues(alpha: .7),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: .1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 40,
                          color: Colors.red.withValues(alpha: .7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Oops! Something went wrong',
                        style: TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF3E2723),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (state.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade600,
                              height: 1.5,
                            ),
                          ),
                        ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                context.read<EditOutfitCubit>().refresh(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF795548),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 12,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Try Again',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => context.router.maybePop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: const Color(
                                  0xFF795548,
                                ).withValues(alpha: .3),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: const Color(
                                  0xFF795548,
                                ).withValues(alpha: .8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.outfit == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9D9CF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search_off_rounded,
                          size: 40,
                          color: const Color(0xFF7B5247).withValues(alpha: .7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Outfit not found',
                        style: TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF3E2723),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'The outfit may have been deleted or doesn\'t exist',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => context.router.maybePop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF795548),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Go Back',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Outfit image preview
                      _buildOutfitImageSection(context, state),

                      // Items in outfit
                      if (state.itemCount > 0) ...[
                        _buildItemsSection(state),
                        const SizedBox(height: 8),
                      ],

                      // Edit Form Section
                      _buildEditFormSection(context, state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOutfitImageSection(BuildContext context, EditOutfitState state) {
    print('🖼️ Building image section - hasImage: ${state.hasImage}, imageUrl: "${state.outfitImageUrl}"');
    
    if (state.hasImage) {
      return OutfitImagePreview(imageUrl: state.outfitImageUrl!);
    }

    return Container(
      margin: const EdgeInsets.all(20),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFE9D9CF),
        border: Border.all(color: const Color(0xFFD7CCC8), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_rounded,
            size: 64,
            color: const Color(0xFF7B5247).withValues(alpha: .6),
          ),
          const SizedBox(height: 12),
          Text(
            'No outfit image',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: const Color(0xFF7B5247).withValues(alpha: .7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(EditOutfitState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D9CF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Items in this outfit',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF3E2723),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5ECE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.itemCount.toString(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF795548),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.itemCount,
              itemBuilder: (context, index) {
                final item = state.outfitItems[index];
                return Container(
                  width: 70,
                  margin: EdgeInsets.only(
                    right: index == state.itemCount - 1 ? 0 : 10,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFFE9D9CF),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildItemImage(item['imagePath']),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['name']?.toString().split(' ').first ?? 'Item',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF795548).withValues(alpha: .7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditFormSection(BuildContext context, EditOutfitState state) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9D9CF), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Outfit Details',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Update your outfit information',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: const Color(0xFF795548).withValues(alpha: .6),
            ),
          ),
          const SizedBox(height: 24),
          const OutfitNameField(),
          const SizedBox(height: 20),
          const OutfitDescriptionField(),
          const SizedBox(height: 20),
          const CategorySelector(), // NEW: Use multi-select instead of dropdown
          const SizedBox(height: 20),
          SeasonDropdown(),
          const SizedBox(height: 32),
          const ActionButtonsRow(),
        ],
      ),
    );
  }

  Widget _buildItemImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        color: const Color(0xFFF5ECE7),
        child: Center(
          child: Icon(
            Icons.photo_outlined,
            color: const Color(0xFF795548).withValues(alpha: .4),
            size: 24,
          ),
        ),
      );
    }

    try {
      if (imagePath.startsWith('assets/')) {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _errorPlaceholder();
          },
        );
      } else {
        return Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _errorPlaceholder();
          },
        );
      }
    } catch (e) {
      return _errorPlaceholder();
    }
  }

  Widget _errorPlaceholder() {
    return Container(
      color: const Color(0xFFF5ECE7),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: const Color(0xFF795548).withValues(alpha: .4),
          size: 24,
        ),
      ),
    );
  }

  void _showCustomSnackBar(BuildContext context, String message, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
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
}