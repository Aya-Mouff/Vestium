import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_item_cubit.dart';

class RemoveBgControls extends StatelessWidget {
  const RemoveBgControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemCubit, EditItemState>(
      builder: (context, state) {
        return Column(
          children: [
            _EraserSizeLabel(eraserSize: state.eraserSize),
            const SizedBox(height: 12),
            _EraserSizeSlider(eraserSize: state.eraserSize),
            const SizedBox(height: 16),
            const _InstructionText(),
          ],
        );
      },
    );
  }
}

class _EraserSizeLabel extends StatelessWidget {
  final double eraserSize;

  const _EraserSizeLabel({required this.eraserSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Eraser Size',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w200,
            color: const Color(0xFF795548).withAlpha((0.8 * 255).toInt()),
            letterSpacing: 0.2,
          ),
        ),
        Text(
          '${eraserSize.round()}px',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w200,
            color: const Color(0xFF795548).withAlpha((0.8 * 255).toInt()),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _EraserSizeSlider extends StatelessWidget {
  final double eraserSize;

  const _EraserSizeSlider({required this.eraserSize});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        activeTrackColor: const Color(0xFF795548),
        inactiveTrackColor: const Color(0xFFD7CCC8),
        thumbColor: const Color(0xFF795548),
        overlayColor: const Color(0xFF795548).withAlpha((0.2 * 255).toInt()),
      ),
      child: Slider(
        value: eraserSize,
        min: 10,
        max: 100,
        onChanged: (value) {
          context.read<EditItemCubit>().updateEraserSize(value);
        },
      ),
    );
  }
}

class _InstructionText extends StatelessWidget {
  const _InstructionText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tap to remove background automatically',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w200,
        color: const Color(0xFF795548).withAlpha((0.7 * 255).toInt()),
        letterSpacing: 0.1,
      ),
    );
  }
}