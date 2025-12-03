// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:vestium/app_router.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../cubit/camera_access_cubit.dart';
// import '../cubit/camera_access_state.dart';
// import 'camera_icon_widget.dart';
// import 'title_description_widget.dart';
// import 'privacy_notice_widget.dart';
// import 'allow_access_button.dart';
// import 'maybe_later_button.dart';

// class CameraAccessBody extends StatelessWidget {
//   const CameraAccessBody({super.key});

//   void _navigateToTakePicScreen(BuildContext context) {
//     context.router.push(const TakePicRoute());
//   }

//   void _handleMaybeLater(BuildContext context) {
//     context.router.maybePop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5ECE7),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 32.0),
//           child: Column(
//             children: [
//               const Spacer(flex: 2),
//               const CameraIconWidget(),
//               const SizedBox(height: 40),
//               const TitleDescriptionWidget(),
//               const SizedBox(height: 32),
//               const PrivacyNoticeWidget(),
//               const Spacer(flex: 3),
//               BlocConsumer<CameraAccessCubit, CameraAccessState>(
//                 listener: (context, state) {
//                   _checkPermissionStatus(context);
                  
//                   if (state.errorMessage != null && context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(state.errorMessage!),
//                         backgroundColor: Colors.red,
//                         duration: const Duration(seconds: 3),
//                       ),
//                     );
//                     context.read<CameraAccessCubit>().clearError();
//                   }
//                 },
//                 builder: (context, state) {
//                   return Column(
//                     children: [
//                       AllowAccessButton(
//                         onPressed: () => context.read<CameraAccessCubit>().requestCameraPermission(),
//                         isLoading: state.isLoading,
//                       ),
//                       const SizedBox(height: 16),
//                       MaybeLaterButton(
//                         onPressed: () => _handleMaybeLater(context),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 32),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _checkPermissionStatus(BuildContext context) async {
//     final status = await Permission.camera.status;
    
//     if (status.isGranted && context.mounted) {
//       _navigateToTakePicScreen(context);
//     }
//   }
// }

// =====================================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../cubit/camera_access_cubit.dart';
import '../cubit/camera_access_state.dart';
import 'camera_icon_widget.dart';
import 'title_description_widget.dart';
import 'privacy_notice_widget.dart';
import 'allow_access_button.dart';
import 'maybe_later_button.dart';

class CameraAccessBody extends StatelessWidget {
  const CameraAccessBody({super.key});

  void _navigateToTakePicScreen(BuildContext context) {
    context.router.replace(const TakePicRoute());
  }

  void _handleMaybeLater(BuildContext context) {
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ADD THIS: Check database permission when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CameraAccessCubit>().checkAndSkipIfAlreadyGranted();
    });
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const CameraIconWidget(),
              const SizedBox(height: 40),
              const TitleDescriptionWidget(),
              const SizedBox(height: 32),
              const PrivacyNoticeWidget(),
              const Spacer(flex: 3),
              BlocConsumer<CameraAccessCubit, CameraAccessState>(
                listener: (context, state) {
                  _checkPermissionStatus(context);
                  
                  // ✅ ADD THIS: Check if shouldNavigate is true
                  if (state.shouldNavigate && context.mounted) {
                    _navigateToTakePicScreen(context);
                    // Reset the flag
                    context.read<CameraAccessCubit>().clearNavigationFlag();
                  }
                  
                  if (state.errorMessage != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    context.read<CameraAccessCubit>().clearError();
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      AllowAccessButton(
                        onPressed: () => context.read<CameraAccessCubit>().requestCameraPermission(),
                        isLoading: state.isLoading,
                      ),
                      const SizedBox(height: 16),
                      MaybeLaterButton(
                        onPressed: () => _handleMaybeLater(context),
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
    );
  }

  Future<void> _checkPermissionStatus(BuildContext context) async {
    final status = await Permission.camera.status;
    
    if (status.isGranted && context.mounted) {
      _navigateToTakePicScreen(context);
    }
  }
}