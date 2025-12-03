import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/item_details_cubit.dart';
import '../cubit/item_details_state.dart';

class ItemNameField extends StatelessWidget {
  const ItemNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Name',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E2723),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
          builder: (context, state) {
            return TextField(
              onChanged: (value) =>
                  context.read<ItemDetailsCubit>().updateName(value),
              controller: TextEditingController(text: state.name),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w200,
                color: Color(0xFF3E2723),
              ),
              decoration: InputDecoration(
                hintText: 'e.g., Blue Denim Jacket',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: const Color(0xFF795548).withValues(alpha: .5),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
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
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}