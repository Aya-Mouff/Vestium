import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vestium/l10n/app_localizations.dart';
import 'cubit/outfit_gallery_access_cubit.dart';
import 'cubit/outfit_gallery_access_state.dart';
import 'widgets/outfit_gallery_icon_widget.dart';
import 'widgets/outfit_gallery_title_description_widget.dart';
import 'widgets/outfit_gallery_privacy_notice_widget.dart';
import 'widgets/outfit_gallery_allow_access_button.dart';
import 'widgets/outfit_gallery_maybe_later_button.dart';

class OutfitGalleryAccessBody extends StatelessWidget {
  final void Function(String imagePath)? onImageSelected;

  const OutfitGalleryAccessBody({super.key, this.onImageSelected});

  void _showSettingsDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          loc.galleryAccessPermissionRequired,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E2723),
          ),
        ),
        content: Text(
          loc.galleryAccessPermissionDenied,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 15, color: Color(0xFF795548)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: Text(
              loc.galleryAccessCancel,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 15, color: Color(0xFF795548)),
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
            child: Text(loc.galleryAccessSettings, style: const TextStyle(fontFamily: 'Inter', fontSize: 15)),
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
    final path = await context.read<OutfitGalleryAccessCubit>().requestGalleryAccess();
    if (path != null && context.mounted) {
      print('✅ Outfit gallery picked: $path');
      Navigator.of(context).pop({
        'id': null, // no DB id yet
        'imageUrl': path, // file path from gallery
        'name': 'Gallery outfit',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive values based on screen size
    final horizontalPadding = screenWidth * 0.08; // 8% of screen width
    final iconSpacing = screenHeight * 0.05; // 5% of screen height
    final titleSpacing = screenHeight * 0.04; // 4% of screen height
    final bottomSpacing = screenHeight * 0.04; // 4% of screen height
    final buttonSpacing = screenHeight * 0.02; // 2% of screen height

    // Determine if screen is small
    final isSmallScreen = screenHeight < 700;

    return BlocListener<OutfitGalleryAccessCubit, OutfitGalleryAccessState>(
      listener: (context, state) {
        if (state.errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: const Color(0xFF795548)));
          context.read<OutfitGalleryAccessCubit>().clearError();
        }
        if (state.permissionGranted == false && !state.isLoading && context.mounted) {
          _showSettingsDialog(context);
        }
      },
      child: BlocBuilder<OutfitGalleryAccessCubit, OutfitGalleryAccessState>(
        builder: (context, state) {
          if (state.checkingExistingPermission) {
            return const Scaffold(
              backgroundColor: Color(0xFFF5ECE7),
              body: Center(child: CircularProgressIndicator(color: Color(0xFF795548))),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF5ECE7),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding.clamp(24.0, 48.0)),
                          child: Column(
                            children: [
                              // Top spacer - reduced on small screens
                              SizedBox(height: isSmallScreen ? 20 : iconSpacing),

                              const OutfitGalleryIconWidget(),

                              SizedBox(height: iconSpacing.clamp(24.0, 40.0)),

                              const OutfitGalleryTitleDescriptionWidget(),

                              SizedBox(height: titleSpacing.clamp(20.0, 32.0)),

                              const OutfitGalleryPrivacyNoticeWidget(),

                              // Flexible spacer that grows to push buttons to bottom
                              const Spacer(),

                              // Buttons section
                              Column(
                                children: [
                                  OutfitGalleryAllowAccessButton(
                                    onPressed: () => _onAllowAccessPressed(context),
                                    isLoading: state.isLoading,
                                  ),
                                  SizedBox(height: buttonSpacing.clamp(12.0, 16.0)),
                                  OutfitGalleryMaybeLaterButton(
                                    onPressed: () => _maybeLater(context),
                                    isLoading: state.isLoading,
                                  ),
                                ],
                              ),

                              SizedBox(height: bottomSpacing.clamp(24.0, 32.0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
