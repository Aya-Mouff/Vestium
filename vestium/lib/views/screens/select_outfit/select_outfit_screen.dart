import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/select_outfit_cubit.dart';
import 'cubit/select_outfit_state.dart';
import 'widgets/select_outfit_app_bar.dart';
import 'widgets/saved_outfits_grid.dart';
import '../../../../repo/outfit_repo.dart';
import 'widgets/gallery_empty_page.dart';

import '../outfit_gallery_access/outfit_gallery_access_body.dart';
import '../outfit_gallery_access/cubit/outfit_gallery_access_cubit.dart';

@RoutePage()
class SelectOutfitScreen extends StatelessWidget {
  final int userId;

  const SelectOutfitScreen({super.key, @PathParam('userId') this.userId = -1});

  @override
  Widget build(BuildContext context) {
    if (userId == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.router.replaceNamed('/access-denied');
      });
    }

    return BlocProvider(
      create: (context) {
        final cubit = SelectOutfitCubit(userId: userId, outfitRepo: context.read<OutfitRepo>());
        cubit.init();
        return cubit;
      },
      child: BlocBuilder<SelectOutfitCubit, SelectOutfitState>(
        builder: (context, state) {
          final cubit = context.read<SelectOutfitCubit>();

          return Scaffold(
            backgroundColor: const Color(0xFFF5EDE8),
            appBar: SelectOutfitAppBar(
              currentIndex: state.currentTabIndex,
              onBack: () => context.router.pop(),
              onTabChanged: cubit.changeTab,
            ),
            body: Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: state.currentTabIndex,
                    children: [
                      SavedOutfitsGrid(
                        isLoading: state.isLoadingSaved,
                        outfits: state.savedOutfits,
                        selectedOutfit: state.selectedOutfit,
                        onRetry: cubit.loadSavedOutfits,
                        onSelect: cubit.selectOutfit,
                      ),
                      BlocProvider(
                        create: (_) => OutfitGalleryAccessCubit(),
                        child: const OutfitGalleryAccessBody(), // no callback
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state.selectedOutfit != null ? () => context.router.pop(state.selectedOutfit) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.selectedOutfit != null
                            ? const Color(0xFF8B6B5C)
                            : const Color(0xFFC4B7AB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
