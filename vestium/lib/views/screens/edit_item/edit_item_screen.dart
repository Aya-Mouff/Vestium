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
    try {
      print('🔧 _handleSave called');

      // Save the edited image and update PhotoPreview state
      final newPath = await _photoPreviewKey.currentState?.confirmEdits();
      
      print('📝 New path from confirmEdits: $newPath');

      if (newPath != null && newPath.isNotEmpty) {
        // Use the cubit from the current context
        context.read<EditItemCubit>().setEditedImagePath(newPath);
        if (mounted) {
          context.read<EditItemCubit>().setEditedImagePath(newPath);
          print('✅ Image saved and state updated: $newPath');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ); 
  }
}