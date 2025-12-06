import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import '../cubit/take_pic_cubit.dart';
import '../cubit/take_pic_state.dart';
import 'take_pic_header.dart';
import 'camera_preview_widget.dart';
import 'camera_placeholder_widget.dart';
import 'bottom_controls_widget.dart';
import '../../edit_item/cubit/edit_item_cubit.dart';
import '../../edit_item/edit_item_screen.dart';

class TakePicBody extends StatefulWidget {
  const TakePicBody({super.key});

  @override
  State<TakePicBody> createState() => _TakePicBodyState();
}

class _TakePicBodyState extends State<TakePicBody> {
  @override
  void initState() {
    super.initState();
    context.read<TakePicCubit>().loadCameras();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TakePicCubit, TakePicState>(
      listener: (context, state) {
        if (state.capturedImagePath != null && context.mounted) {
          // context.router.push(EditItemRoute(imagePath: state.capturedImagePath!));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => EditItemCubit(),
                child: EditItemScreen(imagePath: state.capturedImagePath!),
              ),
            ),
          );
          context.read<TakePicCubit>().clearCapturedImage();
        }
        
        if (state.errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: const Color(0xFF795548),
            ),
          );
          context.read<TakePicCubit>().clearError();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        body: SafeArea(
          child: Column(
            children: [
              const TakePicHeader(),
              // Camera Preview Area - EXACTLY like original
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7CCC8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: BlocBuilder<TakePicCubit, TakePicState>(
                    builder: (context, state) {
                      // Remove padding when camera is active, keep it for placeholder
                      final padding = state.isCameraActive && state.isInitialized 
                          ? EdgeInsets.zero 
                          : const EdgeInsets.all(24);
                      
                      return Container(
                        padding: padding,
                        child: _buildCameraContent(state, context),
                      );
                    },
                  ),
                ),
              ),
              const BottomControlsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraContent(TakePicState state, BuildContext context) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF795548),
        ),
      );
    } else if (state.isCameraActive && state.isInitialized && state.cameraController != null) {
      return CameraPreviewWidget();
    } else {
      return const CameraPlaceholderWidget();
    }
  }
}