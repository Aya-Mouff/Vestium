import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/item_details_cubit.dart';
import '../cubit/item_details_state.dart';

class ItemNameField extends StatefulWidget {
  const ItemNameField({super.key});

  @override
  State<ItemNameField> createState() => _ItemNameFieldState();
}

class _ItemNameFieldState extends State<ItemNameField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          // Only rebuild when name changes (not on every state change)
          buildWhen: (previous, current) => previous.name != current.name,
          builder: (context, state) {
            // Sync controller text with state only when they differ
            if (_controller.text != state.name) {
              _controller.value = TextEditingValue(
                text: state.name,
                selection: TextSelection.collapsed(offset: state.name.length),
              );
            }
            return TextField(
              controller: _controller,
              onChanged: (value) =>
                  context.read<ItemDetailsCubit>().updateName(value),
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