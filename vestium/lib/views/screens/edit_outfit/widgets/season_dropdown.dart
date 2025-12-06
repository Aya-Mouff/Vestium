// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/edit_outfit_cubit.dart';
// import '../cubit/edit_outfit_state.dart';

// class SeasonDropdown extends StatelessWidget {
//   final List<String> seasons = [
//     'Spring',
//     'Summer',
//     'Fall',
//     'Winter',
//     'All Season',
//   ];

//   SeasonDropdown({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Season',
//           style: TextStyle(
//             fontFamily: 'CormorantGaramond',
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: Color(0xFF3E2723),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFFF5ECE7),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: BlocBuilder<EditOutfitCubit, EditOutfitState>(
//             builder: (context, state) {
//               return DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: state.selectedSeason,
//                   hint: Text(
//                     'Select season',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 15,
//                       fontWeight: FontWeight.w200,
//                       color: const Color(0xFF795548).withValues(alpha: .5),
//                     ),
//                   ),
//                   isExpanded: true,
//                   icon: const Icon(
//                     Icons.keyboard_arrow_down,
//                     color: Color(0xFF795548),
//                   ),
//                   style: const TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 15,
//                     fontWeight: FontWeight.w200,
//                     color: Color(0xFF3E2723),
//                   ),
//                   dropdownColor: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   items: seasons.map((String season) {
//                     return DropdownMenuItem<String>(
//                       value: season,
//                       child: Text(season),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     context.read<EditOutfitCubit>().updateSeason(newValue);
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// =============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_outfit_cubit.dart';
import '../cubit/edit_outfit_state.dart';

class SeasonDropdown extends StatelessWidget {
  final List<String> seasons = [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
    'All Season',
  ];

  SeasonDropdown({super.key});

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
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5ECE7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE9D9CF),
              width: 1,
            ),
          ),
          child: BlocBuilder<EditOutfitCubit, EditOutfitState>(
            builder: (context, state) {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.selectedSeason,
                  hint: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Select season',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF795548).withValues(alpha: .5),
                      ),
                    ),
                  ),
                  isExpanded: true,
                  icon: Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF795548).withValues(alpha: .7),
                      size: 20,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF3E2723),
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  menuMaxHeight: 250,
                  elevation: 4,
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      enabled: false,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Select season',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    ...seasons.map((String season) {
                      return DropdownMenuItem<String>(
                        value: season,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            season,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF3E2723),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<EditOutfitCubit>().updateSeason(newValue);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
