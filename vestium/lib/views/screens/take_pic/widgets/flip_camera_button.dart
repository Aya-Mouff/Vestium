import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/take_pic_cubit.dart';
import '../cubit/take_pic_state.dart';

class FlipCameraButton extends StatelessWidget {
  const FlipCameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePicCubit, TakePicState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: state.isInitialized ? () => context.read<TakePicCubit>().flipCamera() : null,
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFD7CCC8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flip_camera_ios_outlined,
              color: Color(0xFF795548),
              size: 24,
            ),
          ),
        );
      },
    );
  }
}