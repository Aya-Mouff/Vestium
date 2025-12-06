// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/save_outfit_cubit.dart';
// import '../cubit/save_outfit_state.dart';

// class DescriptionField extends StatelessWidget {
//   const DescriptionField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
//       builder: (context, state) {
//         final isEnabled = state is SaveOutfitDataLoaded && !state.isSaving;
//         // final description = state is SaveOutfitDataLoaded ? state.description : '';

//         return TextField(
//           enabled: isEnabled,
//           onChanged: (value) =>
//               context.read<SaveOutfitCubit>().updateDescription(value),
//           maxLines: 3,
//           decoration: InputDecoration(
//             hintText: 'Add notes about this outfit...',
//             hintStyle: const TextStyle(
//               color: Color(0xFFA1887F),
//               fontFamily: 'inter',
//               fontSize: 14,
//               fontWeight: FontWeight.w300,
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF5ECE7),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFFD5CCC8), width: 1),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFFD5CCC8), width: 1),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(
//                 color: Color(0xFF795548),
//                 width: 1.5,
//               ),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 14,
//             ),
//           ),
//           style: const TextStyle(
//             fontFamily: 'inter',
//             fontSize: 14,
//             fontWeight: FontWeight.w200,
//             color: Color(0xFF3E2723),
//           ),
//         );
//       },
//     );
//   }
// }

// ========================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/save_outfit_cubit.dart';
import '../cubit/save_outfit_state.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description (optional)',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E2723),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
          builder: (context, state) {
            final isEnabled = state is SaveOutfitDataLoaded && !state.isSaving;

            return TextField(
              enabled: isEnabled,
              onChanged: (value) => context.read<SaveOutfitCubit>().updateDescription(value),
              maxLines: 4,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w200,
                color: Color(0xFF3E2723),
              ),
              decoration: InputDecoration(
                hintText: 'Add notes about this outfit...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: const Color(0xFF795548).withValues(alpha: .5),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF795548),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}