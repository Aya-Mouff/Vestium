import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import './cubit/edit_outfit_cubit.dart';
import './cubit/edit_outfit_state.dart';
import './widgets/edit_outfit_appbar.dart';
import './widgets/outfit_image_preview.dart';
import './widgets/outfit_name_field.dart';
import './widgets/outfit_description_field.dart';
import './widgets/category_dropdown.dart';
import './widgets/season_dropdown.dart';
import './widgets/action_buttons_row.dart';

@RoutePage()
class EditOutfitScreen extends StatelessWidget {
  final String outfitId;

  const EditOutfitScreen({
    super.key,
    @PathParam('outfitId') required this.outfitId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditOutfitCubit(outfitId: outfitId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        appBar: const EditOutfitAppBar(),
        body: BlocBuilder<EditOutfitCubit, EditOutfitState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF795548),
                ),
              );
            }

            if (state.outfit == null || state.hasError) {
              return const Center(
                child: Text(
                  'Error loading outfit data',
                  style: TextStyle(
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
                  // Edit Form
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const OutfitNameField(),
                        const SizedBox(height: 20),
                        const OutfitDescriptionField(),
                        const SizedBox(height: 20),
                        const CategoryDropdown(),
                        const SizedBox(height: 20),
                        SeasonDropdown(),
                        const SizedBox(height: 32),
                        const ActionButtonsRow(),
                      ],
                    ),
                  ),
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