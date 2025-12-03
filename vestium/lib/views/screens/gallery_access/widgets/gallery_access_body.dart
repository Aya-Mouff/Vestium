import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vestium/app_router.dart';
import '../cubit/gallery_access_cubit.dart';
import '../cubit/gallery_access_state.dart';
import 'gallery_icon_widget.dart';
import 'gallery_title_description_widget.dart';
import 'gallery_privacy_notice_widget.dart';
import 'gallery_allow_access_button.dart';
import 'gallery_maybe_later_button.dart';

class GalleryAccessBody extends StatelessWidget {
  const GalleryAccessBody({super.key});

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
    context.router.maybePop(false);
  }

  Future<void> _onAllowAccessPressed(BuildContext context) async {
    // First check current permission status
    var status = await Permission.photos.status;
    
    if (status.isDenied) {
      // Request permission
      status = await Permission.photos.request();
    }
    
    if (status.isGranted || status.isLimited) {
      // Permission granted - navigate to SelectOutfitScreen
      if (context.mounted) {
        // You need to pass the userId here - you might need to get it from somewhere
        // For now, using a placeholder userId of 1
        context.router.push(SelectItemRoute());
      }
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied - show settings dialog
      if (context.mounted) {
        _showSettingsDialog(context);
      }
    }
    // If still denied (not permanently), do nothing - user can try again
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GalleryAccessCubit, GalleryAccessState>(
      listener: (context, state) {
        // Handle errors
        if (state.errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: const Color(0xFF795548),
            ),
          );
          context.read<GalleryAccessCubit>().clearError();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const GalleryIconWidget(),
                const SizedBox(height: 40),
                const GalleryTitleDescriptionWidget(),
                const SizedBox(height: 32),
                const GalleryPrivacyNoticeWidget(),
                const Spacer(flex: 3),
                BlocBuilder<GalleryAccessCubit, GalleryAccessState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        GalleryAllowAccessButton(
                          onPressed: () => _onAllowAccessPressed(context),
                          isLoading: state.isLoading,
                        ),
                        const SizedBox(height: 16),
                        GalleryMaybeLaterButton(
                          onPressed: () => _maybeLater(context),
                          isLoading: state.isLoading,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}