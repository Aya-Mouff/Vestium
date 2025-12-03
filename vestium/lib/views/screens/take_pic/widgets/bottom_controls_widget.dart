import 'package:flutter/material.dart';
import 'capture_button.dart';
import 'gallery_button.dart';
import 'flip_camera_button.dart';

class BottomControlsWidget extends StatelessWidget {
  const BottomControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          GalleryButton(),
          CaptureButton(),
          FlipCameraButton(),
        ],
      ),
    );
  }
}