// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/save_outfit_cubit.dart';
// import '../cubit/save_outfit_state.dart';

// class ItemsCountDisplay extends StatelessWidget {
//   const ItemsCountDisplay({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
//       builder: (context, state) {
//         final itemsCount = state is SaveOutfitDataLoaded ? state.itemsCount : 0;

//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF5ECE7),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: const Color(0xFFD5CCC8),
//               width: 1,
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.layers_outlined,
//                 color: Color(0xFF795548),
//                 size: 24,
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 '$itemsCount item${itemsCount != 1 ? 's' : ''} in outfit',
//                 style: const TextStyle(
//                   fontFamily: 'CormorantGaramond',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF3E2723),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/save_outfit_cubit.dart';
import '../cubit/save_outfit_state.dart';

class ItemsCountDisplay extends StatelessWidget {
  const ItemsCountDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
      builder: (context, state) {
        final itemsCount = state is SaveOutfitDataLoaded ? state.itemsCount : 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5ECE7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD7CCC8),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.layers_outlined,
                color: Color(0xFF795548),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '$itemsCount item${itemsCount != 1 ? 's' : ''} in outfit',
                style: const TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3E2723),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}