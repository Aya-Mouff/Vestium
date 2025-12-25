// // lib/wardrobe_screen/widgets/wardrobe_app_bar.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/wardrobe_cubit.dart';
// import '../cubit/wardrobe_state.dart';

// class WardrobeAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const WardrobeAppBar({super.key});

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       centerTitle: true,
//       title: BlocBuilder<WardrobeCubit, WardrobeState>(
//         builder: (context, state) {
//           return Column(
//             children: [
//               const Text(
//                 'My Wardrobe',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               if (state.selectedFilter != 'All')
//                 Text(
//                   '${state.items.length} item${state.items.length != 1 ? 's' : ''}',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//       actions: [
//         BlocBuilder<WardrobeCubit, WardrobeState>(
//           builder: (context, state) {
//             return IconButton(
//               icon: state.isLoading
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Color(0xFF8B6B61),
//                       ),
//                     )
//                   : const Icon(Icons.refresh, color: Color(0xFF8B6B61)),
//               onPressed: state.isLoading
//                   ? null
//                   : () => context.read<WardrobeCubit>().refresh(),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// =========================================================================

// lib/wardrobe_screen/widgets/wardrobe_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/wardrobe_cubit.dart';
import '../cubit/wardrobe_state.dart';

class WardrobeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WardrobeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF), // White background
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000), // Light shadow
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title section with refresh button
          SizedBox(
            height: 90, // Fixed height for title area
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Builder(
                        builder: (context) {
                          final loc = AppLocalizations.of(context)!;
                          return Text(
                            loc.wardrobeMyWardrobe,
                            style: const TextStyle(
                              fontFamily: 'CormorantGaramond',
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF3E2723), // Dark brown text
                              letterSpacing: 0.2,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Refresh button - KEEP YOUR ORIGINAL LOGIC
                  BlocBuilder<WardrobeCubit, WardrobeState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: state.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF795548), // Primary brown
                                ),
                              )
                            : const Icon(
                                Icons.refresh,
                                color: Color(0xFF795548), // Primary brown
                                size: 24,
                              ),
                        onPressed: state.isLoading ? null : () => context.read<WardrobeCubit>().refresh(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Categories section - This replaces the FilterChipsWidget
          SizedBox(
            height: 50, // Fixed height for categories
            child: BlocBuilder<WardrobeCubit, WardrobeState>(
              builder: (context, state) {
                // Show loading state if categories are loading
                if (state.isLoading && state.categories.isEmpty) {
                  return const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF795548)),
                    ),
                  );
                }

                // Create filters: "All" + categories (KEEPING YOUR LOGIC)
                final filters = <Map<String, dynamic>>[
                  {'label': 'All', 'icon': null},
                  ...state.categories.map(
                    (category) => {'label': category.categoryName, 'icon': null, 'id': category.categoryId},
                  ),
                ];

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (_, i) {
                    final f = filters[i];
                    final label = f['label'] as String?;
                    final isSelected = state.selectedFilter == label;

                    // KEEPING YOUR ORIGINAL TAP LOGIC
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          if (label != null) {
                            context.read<WardrobeCubit>().changeFilter(label);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF795548) // Selected: primary brown
                                : const Color(0xFFFFFFFF), // Unselected: white
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF795548) // Selected: primary brown
                                  : const Color(0xFFD7CCC8), // Unselected: light brown border
                              width: 1,
                            ),
                          ),
                          child: Text(
                            label ?? '',
                            style: TextStyle(
                              fontFamily: 'Inter', // Secondary font
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                              color: isSelected
                                  ? const Color(0xFFFFFFFF) // Selected: white text
                                  : const Color(0xFF795548), // Unselected: primary brown text
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
