import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/item_details_cubit.dart';
import '../cubit/item_details_state.dart';

class SeasonDropdown extends StatelessWidget {
  final List<String> seasons = ['Spring', 'Summer', 'Fall', 'Winter', 'All Season'];

  SeasonDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.itemDetailsSeason,
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
          decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
            builder: (context, state) {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.selectedSeason,
                  hint: Text(
                    loc.itemDetailsSeasonHint,
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
                    context.read<ItemDetailsCubit>().updateSeason(newValue);
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
        return loc.itemDetailsSeasonSpring;
      case 'Summer':
        return loc.itemDetailsSeasonSummer;
      case 'Fall':
        return loc.itemDetailsSeasonFall;
      case 'Winter':
        return loc.itemDetailsSeasonWinter;
      case 'All Season':
        return loc.itemDetailsSeasonAllSeason;
      default:
        return season;
    }
  }
}
