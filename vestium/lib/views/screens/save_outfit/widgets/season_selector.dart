// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/save_outfit_cubit.dart';
// import '../cubit/save_outfit_state.dart';

// class SeasonSelector extends StatelessWidget {
//   const SeasonSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
//       builder: (context, state) {
//         final isEnabled = state is SaveOutfitDataLoaded && !state.isSaving;
//         final selectedSeason = state is SaveOutfitDataLoaded ? state.selectedSeason : null;

//         return DropdownButtonFormField<String>(
//           initialValue: selectedSeason,
//           hint: const Text(
//             'Select season',
//             style: TextStyle(
//               fontFamily: 'CormorantGaramond',
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: Color(0xFFA1887F),
//             ),
//           ),
//           items: [
//             'All Seasons',
//             'Spring',
//             'Summer', 
//             'Fall',
//             'Winter',
//           ].map((season) {
//             return DropdownMenuItem(
//               value: season,
//               child: Text(
//                 season,
//                 style: const TextStyle(
//                   fontFamily: 'CormorantGaramond',
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   color: Color(0xFF3E2723),
//                 ),
//               ),
//             );
//           }).toList(),
//           onChanged: isEnabled
//               ? (value) => context.read<SaveOutfitCubit>().updateSeason(value)
//               : null,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: const Color(0xFFF5ECE7),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(
//                 color: Color(0xFFD5CCC8),
//                 width: 1,
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(
//                 color: Color(0xFFD5CCC8),
//                 width: 1,
//               ),
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
//           icon: const Icon(
//             Icons.arrow_drop_down,
//             color: Color(0xFF795548),
//           ),
//           dropdownColor: const Color(0xFFF5ECE7),
//         );
//       },
//     );
//   }
// }

// ================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/save_outfit_cubit.dart';
import '../cubit/save_outfit_state.dart';

class SeasonSelector extends StatelessWidget {
  const SeasonSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Season',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E2723),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
            builder: (context, state) {
              final isEnabled = state is SaveOutfitDataLoaded && !state.isSaving;
              final selectedSeason = state is SaveOutfitDataLoaded ? state.selectedSeason : null;

              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSeason,
                  hint: Text(
                    'Select season',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      color: const Color(0xFF795548).withValues(alpha: .5),
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF795548),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF3E2723),
                  ),
                  dropdownColor: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  items: [
                    'All',
                    'Spring',
                    'Summer', 
                    'Fall',
                    'Winter',
                  ].map((season) {
                    return DropdownMenuItem<String>(
                      value: season,
                      child: Text(season),
                    );
                  }).toList(),
                  onChanged: isEnabled
                      ? (value) => context.read<SaveOutfitCubit>().updateSeason(value)
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}