import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/l10n/app_localizations.dart';
import './cubit/outfit_details_cubit.dart';
import './cubit/outfit_details_state.dart';
import './widgets/outfit_details_appbar.dart';
import './widgets/outfit_image_preview.dart';
import './widgets/outfit_info_card.dart';
import './widgets/outfit_items_list.dart';
import './widgets/outfit_action_buttons.dart';

@RoutePage()
class OutfitDetailsScreen extends StatelessWidget {
  final String outfitId;

  const OutfitDetailsScreen({super.key, @PathParam('outfitId') required this.outfitId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OutfitDetailsCubit(outfitId: outfitId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        appBar: OutfitDetailsAppBar(outfitId: outfitId),
        body: BlocBuilder<OutfitDetailsCubit, OutfitDetailsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.outfit == null || state.hasError) {
              final loc = AppLocalizations.of(context)!;
              return Center(
                child: Text(
                  loc.outfitDetailsError,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF3E2723),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  OutfitImagePreview(imageUrl: state.outfit!['imageUrl']),
                  const SizedBox(height: 16),
                  OutfitInfoCard(outfit: state.outfit!),
                  const SizedBox(height: 16),
                  OutfitItemsList(items: state.items),
                  const SizedBox(height: 16),
                  const OutfitActionButtons(),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
