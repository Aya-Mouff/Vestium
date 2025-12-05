import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_item_cubit.dart';

class RemoveBgControls extends StatelessWidget {
  final VoidCallback? onReset;

  const RemoveBgControls({
    super.key,
    this.onReset,
  });

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
            _ActionButtons(onReset: onReset),
            const SizedBox(height: 12),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD7CCC8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${eraserSize.round()}px',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF795548),
              letterSpacing: 0.2,
            ),
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
        divisions: 18,
        label: '${eraserSize.round()}px',
        onChanged: (value) {
          context.read<EditItemCubit>().updateEraserSize(value);
        },
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback? onReset;

  const _ActionButtons({this.onReset});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text(
              'Reset',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w200,
                letterSpacing: 0.2,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF795548),
              side: const BorderSide(color: Color(0xFF795548), width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InstructionText extends StatelessWidget {
  const _InstructionText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Draw on the image to remove background',
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