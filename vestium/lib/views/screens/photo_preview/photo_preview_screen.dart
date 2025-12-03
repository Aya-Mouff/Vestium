import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import './cubit/photo_preview_cubit.dart';
import './cubit/photo_preview_state.dart';
import './widgets/photo_preview_header.dart';
import './widgets/photo_preview_image.dart';
import './widgets/photo_action_buttons.dart';

@RoutePage()
class PhotoPreviewScreen extends StatelessWidget {
  final String imagePath;

  const PhotoPreviewScreen({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotoPreviewCubit(imagePath: imagePath),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        body: SafeArea(
          child: Column(
            children: [
              const PhotoPreviewHeader(),
              BlocBuilder<PhotoPreviewCubit, PhotoPreviewState>(
                builder: (context, state) {
                  return PhotoPreviewImage(imagePath: state.imagePath);
                },
              ),
              PhotoActionButtons(imagePath: imagePath),
            ],
          ),
        ),
      ),
    );
  }
}