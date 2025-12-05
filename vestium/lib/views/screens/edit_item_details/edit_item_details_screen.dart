// lib/edit_item_details_screen/edit_item_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
//import 'package:vestium/databases/services/edit_item_service.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import './cubit/edit_item_details_cubit.dart';
import './cubit/edit_item_details_state.dart';
import './widgets/edit_item_header.dart';
import './widgets/edit_item_image_preview.dart';
import './widgets/edit_item_name_field.dart';
import './widgets/edit_item_description_field.dart';
import './widgets/edit_item_season_dropdown.dart';
import './widgets/edit_item_categories_selection.dart';
import './widgets/edit_item_action_buttons.dart';

@RoutePage()
class EditItemDetailsScreen extends StatefulWidget {
  final int itemId;

  const EditItemDetailsScreen({
    super.key,
    required this.itemId,
  });

  @override
  State<EditItemDetailsScreen> createState() => _EditItemDetailsScreenState();
}

class _EditItemDetailsScreenState extends State<EditItemDetailsScreen> {
  late EditItemDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = EditItemDetailsCubit(itemId: widget.itemId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = CurrentUserService.currentUserId;
    if (userId == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please log in to edit items',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              color: Color(0xFF3E2723),
            ),
          ),
        ),
      );
    }

    return BlocProvider.value(
      value: _cubit,
      child: _EditItemDetailsContent(itemId: widget.itemId),
    );
  }
}

class _EditItemDetailsContent extends StatelessWidget {
  final int itemId;

  const _EditItemDetailsContent({required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F2),
      body: BlocBuilder<EditItemDetailsCubit, EditItemDetailsState>(
        builder: (context, state) {
          if (state.isLoading && state.item == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF795548),
              ),
            );
          }

          if (state.item == null) {
            return const Center(
              child: Text(
                'Item not found',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  color: Color(0xFF3E2723),
                ),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const EditItemHeader(),
                  
                  // Image Preview
                  EditItemImagePreview(imagePath: state.item!.imagePath),
                  
                  // Form Container
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF795548).withValues(alpha: .1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Name
                        const EditItemNameField(),
                        
                        const SizedBox(height: 20),
                        
                        // Description
                        const EditItemDescriptionField(),
                        
                        const SizedBox(height: 20),
                        
                        // Season
                        EditItemSeasonDropdown(),
                        
                        const SizedBox(height: 20),
                        
                        // Categories
                        const EditItemCategoriesSelection(),
                      ],
                    ),
                  ),
                  
                  // Action Buttons
                  const EditItemActionButtons(),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}