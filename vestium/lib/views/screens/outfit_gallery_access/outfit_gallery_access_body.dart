import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'cubit/outfit_gallery_access_cubit.dart';
import 'cubit/outfit_gallery_access_state.dart';
import 'widgets/outfit_gallery_icon_widget.dart';
import 'widgets/outfit_gallery_title_description_widget.dart';
import 'widgets/outfit_gallery_privacy_notice_widget.dart';
import 'widgets/outfit_gallery_allow_access_button.dart';
import 'widgets/outfit_gallery_maybe_later_button.dart';

class OutfitGalleryAccessBody extends StatelessWidget {
  final void Function(String imagePath)? onImageSelected;

  const OutfitGalleryAccessBody({
    super.key,
    this.onImageSelected,
  });

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Permission Required',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E2723),
          ),
        ),
        content: const Text(
          'Gallery access has been permanently denied. Please enable it in app settings.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            color: Color(0xFF795548),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: Color(0xFF795548),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).maybePop();
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF795548),
              foregroundColor: const Color(0xFFFFFFFF),
              elevation: 0,
            ),
            child: const Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _maybeLater(BuildContext context) {
    // For outfit selection, maybe just stay on this page or switch back to Saved tab
    // You can call Navigator.of(context).maybePop() if you ever push this screen.
  }

 Future<void> _onAllowAccessPressed(BuildContext context) async {
  final path =
      await context.read<OutfitGalleryAccessCubit>().requestGalleryAccess();

  if (path != null && context.mounted) {
    print('✅ Outfit gallery picked: $path');
    Navigator.of(context).pop({
      'id': null,             // no DB id yet
      'imageUrl': path,       // file path from gallery
      'name': 'Gallery outfit',
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return BlocListener<OutfitGalleryAccessCubit, OutfitGalleryAccessState>(
      listener: (context, state) {
        if (state.errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: const Color(0xFF795548),
            ),
          );
          context.read<OutfitGalleryAccessCubit>().clearError();
        }

        if (state.permissionGranted == false &&
            !state.isLoading &&
            context.mounted) {
          _showSettingsDialog(context);
        }
      },
      child: BlocBuilder<OutfitGalleryAccessCubit, OutfitGalleryAccessState>(
        builder: (context, state) {
          if (state.checkingExistingPermission) {
            return const Scaffold(
              backgroundColor: Color(0xFFF5ECE7),
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF795548),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF5ECE7),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    const OutfitGalleryIconWidget(),
                    const SizedBox(height: 40),
                    const OutfitGalleryTitleDescriptionWidget(),
                    const SizedBox(height: 32),
                    const OutfitGalleryPrivacyNoticeWidget(),
                    const Spacer(flex: 3),
                    Column(
                      children: [
                        OutfitGalleryAllowAccessButton(
                          onPressed: () => _onAllowAccessPressed(context),
                          isLoading: state.isLoading,
                        ),
                        const SizedBox(height: 16),
                        OutfitGalleryMaybeLaterButton(
                          onPressed: () => _maybeLater(context),
                          isLoading: state.isLoading,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
