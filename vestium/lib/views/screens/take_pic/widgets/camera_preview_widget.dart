import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/take_pic_cubit.dart';
import '../cubit/take_pic_state.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePicCubit, TakePicState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Camera preview fills the entire container - EXACTLY like original
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: state.cameraController!.value.previewSize!.height,
                    height: state.cameraController!.value.previewSize!.width,
                    child: CameraPreview(state.cameraController!),
                  ),
                ),
              ),
              // Close button to go back to placeholder
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () => context.read<TakePicCubit>().stopCamera(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}