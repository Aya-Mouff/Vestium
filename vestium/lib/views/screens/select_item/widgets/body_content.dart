import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../gallery_access/cubit/gallery_access_cubit.dart';
import '../../gallery_access/cubit/gallery_access_state.dart';
import '../cubit/select_item_state.dart';
import '../cubit/select_item_cubit.dart';
import 'package:vestium/app_router.dart';
import 'gallery_grid_view.dart';
import 'continue_button.dart';

class BodyContent extends StatelessWidget {
  const BodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GalleryAccessCubit, GalleryAccessState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
              context.read<GalleryAccessCubit>().clearError();
            }
          },
        ),
        BlocListener<SelectItemCubit, SelectItemState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
              context.read<SelectItemCubit>().clearError();
            }
          },
        ),
      ],
      child: BlocBuilder<SelectItemCubit, SelectItemState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: GalleryGridView(
                  galleryItems: state.galleryItems,
                  selectedItem: state.selectedGalleryItem,
                  onItemSelected: (galleryItem) =>
                      context.read<SelectItemCubit>().selectGalleryItem(galleryItem),
                ),
              ),
              ContinueButton(
                isEnabled: state.selectedGalleryItem != null,
                onPressed: () {
                  if (state.selectedGalleryItem != null) {
                    _navigateToEditItemScreen(context, state.selectedGalleryItem!);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToEditItemScreen(BuildContext context, Map<String, dynamic> selectedItem) {
    final imagePath = selectedItem['filePath'] as String?;
    
    if (imagePath != null) {
      // Navigate to EditItemScreen with the image path
      context.router.push(
        EditItemRoute(imagePath: imagePath),
      );
    }
  }
}