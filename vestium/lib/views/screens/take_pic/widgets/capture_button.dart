import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/take_pic_cubit.dart';
import '../cubit/take_pic_state.dart';

class CaptureButton extends StatelessWidget {
  const CaptureButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePicCubit, TakePicState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: state.isInitialized ? () => _onCapturePressed(context) : null,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFFFFF),
              border: Border.all(
                color: const Color(0xFF795548),
                width: 8,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF795548),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onCapturePressed(BuildContext context) {
    context.read<TakePicCubit>().capturePhoto();
    
  }
}