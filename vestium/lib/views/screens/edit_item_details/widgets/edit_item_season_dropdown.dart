// lib/edit_item_details_screen/widgets/edit_item_season_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_item_details_cubit.dart';
import '../cubit/edit_item_details_state.dart';

class EditItemSeasonDropdown extends StatelessWidget {
  final List<String> seasons = [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
    'All Season',
  ];

  EditItemSeasonDropdown({super.key});

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
            border: Border.all(
              color: const Color(0xFF795548), // Border color
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<EditItemDetailsCubit, EditItemDetailsState>(
            buildWhen: (previous, current) =>
                previous.selectedSeason != current.selectedSeason,
            builder: (context, state) {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.selectedSeason.isNotEmpty ? state.selectedSeason : null,
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
                  items: seasons.map((String season) {
                    return DropdownMenuItem<String>(
                      value: season,
                      child: Text(season),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<EditItemDetailsCubit>().updateSeason(newValue);
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