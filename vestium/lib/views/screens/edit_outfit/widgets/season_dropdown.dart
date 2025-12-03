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
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<EditOutfitCubit, EditOutfitState>(
            builder: (context, state) {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.selectedSeason,
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
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  items: seasons.map((String season) {
                    return DropdownMenuItem<String>(
                      value: season,
                      child: Text(season),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    context.read<EditOutfitCubit>().updateSeason(newValue);
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