import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'cubit/edit_item_cubit.dart';
import 'widgets/edit_item_header.dart';
import 'widgets/photo_preview.dart';
import 'widgets/bottom_actions.dart';

@RoutePage()
class EditItemScreen extends StatefulWidget {
  final String imagePath;
  final int? itemId; // Optional: if editing an existing item

  const EditItemScreen({super.key, required this.imagePath, this.itemId});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final GlobalKey<PhotoPreviewState> _photoPreviewKey =
      GlobalKey<PhotoPreviewState>();
  Future<void> _handleSave() async {
    try {
      print('🔧 _handleSave called');

      // Store router reference before async operation
      final router = context.router;
      final editItemCubit = context.read<EditItemCubit>();
      final itemId = widget.itemId;

      // Save the edited image and update PhotoPreview state
      final newPath = await _photoPreviewKey.currentState?.confirmEdits();

      print('📝 New path from confirmEdits: $newPath');

      if (newPath != null && newPath.isNotEmpty) {
        // Update the cubit
        editItemCubit.setEditedImagePath(newPath);
        print('✅ Image saved and state updated: $newPath');

        // If editing an existing item, navigate to EditItemDetailsRoute with the edited image
        if (itemId != null && mounted) {
          print(
            '📤 Navigating to EditItemDetailsRoute with itemId: $itemId, editedImagePath: $newPath',
          );
          router.push(
            EditItemDetailsRoute(itemId: itemId, editedImagePath: newPath),
          );
        }
      } else {
        print('⚠️ No new path returned');
      }
    } catch (e, stackTrace) {
      print('❌ Error in _handleSave: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save edited image: $e'),
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

  Future<void> _handleCropDone() async {
    print('🔍 _handleCropDone called - saving crop');
    try {
      final newPath = await _photoPreviewKey.currentState?.saveCroppedImage();
      if (newPath != null) {
        print('✅ Crop saved: $newPath');
        context.read<EditItemCubit>().setEditedImagePath(newPath);
      }
    } catch (e) {
      print('❌ Error saving crop: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving crop: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SafeArea(
        child: Column(
          children: [
            EditItemHeader(imagePath: widget.imagePath, onSave: _handleSave),
            PhotoPreview(key: _photoPreviewKey, imagePath: widget.imagePath),
            BottomActions(onReset: _handleReset, onCropDone: _handleCropDone),
          ],
        ),
      ),
    );
  }
}
