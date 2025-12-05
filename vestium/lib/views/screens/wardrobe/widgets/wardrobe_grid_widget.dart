// // lib/wardrobe_screen/widgets/wardrobe_grid_widget.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/wardrobe_cubit.dart';
// import '../cubit/wardrobe_state.dart';
// import 'wardrobe_item_card.dart';

// class WardrobeGridWidget extends StatelessWidget {
//   const WardrobeGridWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<WardrobeCubit, WardrobeState>(
//       builder: (context, state) {
//         return GridView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 0.75,
//           ),
//           itemCount: state.items.length,
//           itemBuilder: (_, index) => WardrobeItemCard(item: state.items[index]),
//         );
//       },
//     );
//   }
// }

// ================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/wardrobe_cubit.dart';
import '../cubit/wardrobe_state.dart';
import 'wardrobe_item_card.dart';

class WardrobeGridWidget extends StatelessWidget {
  const WardrobeGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WardrobeCubit, WardrobeState>(
      builder: (context, state) {
        return GridView.builder(
          padding: const EdgeInsets.all(16), // Reduced from 16
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12, // Reduced from 16
            mainAxisSpacing: 13, // Reduced from 16
            childAspectRatio: 0.46, 
          ),
          itemCount: state.items.length,
          itemBuilder: (_, index) => WardrobeItemCard(item: state.items[index]),
        );
      },
    );
  }
}