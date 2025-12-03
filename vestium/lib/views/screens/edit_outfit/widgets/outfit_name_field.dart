import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_outfit_cubit.dart';
import '../cubit/edit_outfit_state.dart';

class OutfitNameField extends StatelessWidget {
  const OutfitNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Outfit Name',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E2723),
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<EditOutfitCubit, EditOutfitState>(
          builder: (context, state) {
            return TextField(
              onChanged: (value) => context.read<EditOutfitCubit>().updateName(value),
              controller: TextEditingController(text: state.name),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w200,
                color: Color(0xFF3E2723),
              ),
              decoration: InputDecoration(
                hintText: 'e.g., Summer Casual',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: const Color(0xFF795548).withValues(alpha: .5),
                ),
                filled: true,
                fillColor: const Color(0xFFF5ECE7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF795548),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}