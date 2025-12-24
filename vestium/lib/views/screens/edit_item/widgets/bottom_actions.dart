import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_item_cubit.dart';
import 'edit_buttons.dart';
import 'remove_bg_controls.dart';
import 'crop_controls.dart';

class BottomActions extends StatelessWidget {
  final VoidCallback? onReset;
  final VoidCallback? onCropDone;

  const BottomActions({super.key, this.onReset, this.onCropDone});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemCubit, EditItemState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
          ),
          child: state.isRemovingBg
              ? RemoveBgControls(onReset: onReset)
              : state.isCropping
              ? CropControls(onReset: onReset, onCropDone: onCropDone)
              : const EditButtons(),
        );
      },
    );
  }
}
