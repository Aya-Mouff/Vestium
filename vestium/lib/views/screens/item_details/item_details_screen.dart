// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:auto_route/auto_route.dart';
// import './cubit/item_details_cubit.dart';
// import './cubit/item_details_state.dart';
// import './widgets/item_details_header.dart';
// import './widgets/item_image_preview.dart';
// import './widgets/item_name_field.dart';
// import './widgets/item_description_field.dart';
// import './widgets/season_dropdown.dart';
// import './widgets/categories_selection.dart';
// import './widgets/add_to_wardrobe_button.dart';

// @RoutePage()
// class ItemDetailsScreen extends StatelessWidget {
//   final String imagePath;

//   const ItemDetailsScreen({
//     super.key,
//     required this.imagePath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ItemDetailsCubit(imagePath: imagePath),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5ECE7),
//         body: SafeArea(
//           child: Column(
//             children: [
//               const ItemDetailsHeader(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
//                         builder: (context, state) {
//                           return ItemImagePreview(imagePath: state.imagePath);
//                         },
//                       ),
//                       const SizedBox(height: 24),
//                       const ItemNameField(),
//                       const SizedBox(height: 20),
//                       const ItemDescriptionField(),
//                       const SizedBox(height: 20),
//                       SeasonDropdown(),
//                       const SizedBox(height: 20),
//                       CategoriesSelection(),
//                       const SizedBox(height: 32),
//                     ],
//                   ),
//                 ),
//               ),
//               const AddToWardrobeButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ====================================================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import './cubit/item_details_cubit.dart';
import './cubit/item_details_state.dart';
import './widgets/item_details_header.dart';
import './widgets/item_image_preview.dart';
import './widgets/item_name_field.dart';
import './widgets/item_description_field.dart';
import './widgets/season_dropdown.dart';
import './widgets/categories_selection.dart';
import './widgets/add_to_wardrobe_button.dart';

@RoutePage()
class ItemDetailsScreen extends StatelessWidget {
  final String imagePath;

  const ItemDetailsScreen({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemDetailsCubit(imagePath: imagePath),
      child: BlocListener<ItemDetailsCubit, ItemDetailsState>(
        listener: (context, state) {
          // Handle errors
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<ItemDetailsCubit>().clearError();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5ECE7),
          body: SafeArea(
            child: Column(
              children: [
                const ItemDetailsHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
                          builder: (context, state) {
                            return ItemImagePreview(imagePath: state.imagePath);
                          },
                        ),
                        const SizedBox(height: 24),
                        const ItemNameField(),
                        const SizedBox(height: 20),
                        const ItemDescriptionField(),
                        const SizedBox(height: 20),
                        SeasonDropdown(),
                        const SizedBox(height: 20),
                        const CategoriesSelection(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                const AddToWardrobeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
