// lib/edit_item_details_screen/widgets/edit_item_season_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/edit_item_details_cubit.dart';
import '../cubit/edit_item_details_state.dart';

class EditItemSeasonDropdown extends StatelessWidget {
  final List<String> seasons = ['Spring', 'Summer', 'Fall', 'Winter', 'All Season'];

  EditItemSeasonDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.editItemDetailsSeason,
          style: const TextStyle(
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
            buildWhen: (previous, current) => previous.selectedSeason != current.selectedSeason,
            builder: (context, state) {
              // Normalize the season value to English constant if it's localized
              String? normalizedSeason = _normalizeSeasonValue(state.selectedSeason);

              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: normalizedSeason != null && normalizedSeason.isNotEmpty ? normalizedSeason : null,
                  hint: Text(
                    loc.editItemDetailsSeasonHint,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      color: const Color(0xFF795548).withValues(alpha: .5),
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF795548)),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF3E2723),
                  ),
                  dropdownColor: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  items: seasons.map((String season) {
                    String displayName = _getLocalizedSeason(loc, season);
                    return DropdownMenuItem<String>(value: season, child: Text(displayName));
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

  String _getLocalizedSeason(AppLocalizations loc, String season) {
    switch (season) {
      case 'Spring':
        return loc.editItemDetailsSpring;
      case 'Summer':
        return loc.editItemDetailsSummer;
      case 'Fall':
        return loc.editItemDetailsFall;
      case 'Winter':
        return loc.editItemDetailsWinter;
      case 'All Season':
        return loc.editItemDetailsAllSeason;
      default:
        return season;
    }
  }

  String? _normalizeSeasonValue(String? season) {
    if (season == null || season.isEmpty) return null;

    // If it's already an English constant, return it
    if (seasons.contains(season)) return season;

    // Check if it's a localized value and convert to English constant
    // French
    if (season == 'Printemps') return 'Spring';
    if (season == 'Été') return 'Summer';
    if (season == 'Automne') return 'Fall';
    if (season == 'Hiver') return 'Winter';
    if (season == 'Toutes les saisons' || season == 'Toute saison') return 'All Season';

    // Arabic
    if (season == 'الربيع') return 'Spring';
    if (season == 'الصيف') return 'Summer';
    if (season == 'الخريف') return 'Fall';
    if (season == 'الشتاء') return 'Winter';
    if (season == 'جميع الفصول') return 'All Season';

    // Italian
    if (season == 'Primavera') return 'Spring';
    if (season == 'Estate') return 'Summer';
    if (season == 'Autunno') return 'Fall';
    if (season == 'Inverno') return 'Winter';
    if (season == 'Tutte le stagioni') return 'All Season';

    // If not recognized, return null to show hint instead
    return null;
  }
}
