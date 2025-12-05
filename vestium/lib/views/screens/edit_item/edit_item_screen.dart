import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'cubit/edit_item_cubit.dart';
import 'widgets/edit_item_header.dart';
import 'widgets/photo_preview.dart';
import 'widgets/bottom_actions.dart';

@RoutePage()
class EditItemScreen extends StatefulWidget {
  final String imagePath;

  const EditItemScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final GlobalKey<PhotoPreviewState> _photoPreviewKey = GlobalKey<PhotoPreviewState>();

  Future<void> _handleSave() async {
    final cubit = context.read<EditItemCubit>();
    
    // Save the edited image
    final newPath = await _photoPreviewKey.currentState?.saveEditedImage();
    
    if (newPath != null) {
      // Update the cubit with the new image path
      cubit.setEditedImagePath(newPath);
      print('✅ Image saved and state updated: $newPath');
    } else {
      print('❌ Failed to save image');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save edited image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleReset() {
    _photoPreviewKey.currentState?.resetImage();
    context.read<EditItemCubit>().clearEditedImage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditItemCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        body: SafeArea(
          child: Column(
            children: [
              EditItemHeader(
                imagePath: widget.imagePath,
                onSave: _handleSave,
              ),
              PhotoPreview(
                key: _photoPreviewKey,
                imagePath: widget.imagePath,
              ),
              BottomActions(onReset: _handleReset),
            ],
          ),
        ),
      ),
    );
  }
}