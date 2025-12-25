// lib/edit_item_details_screen/widgets/edit_item_name_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/edit_item_details_cubit.dart';
import '../cubit/edit_item_details_state.dart';

class EditItemNameField extends StatefulWidget {
  const EditItemNameField({super.key});

  @override
  State<EditItemNameField> createState() => _EditItemNameFieldState();
}

class _EditItemNameFieldState extends State<EditItemNameField> {
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
    return BlocBuilder<EditItemDetailsCubit, EditItemDetailsState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        final loc = AppLocalizations.of(context)!;
        if (_controller.text != state.name) {
          _controller.value = TextEditingValue(
            text: state.name,
            selection: TextSelection.collapsed(offset: state.name.length),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.editItemDetailsItemName,
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3E2723),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF795548), // Border color
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                onChanged: (value) => context.read<EditItemDetailsCubit>().updateName(value),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: Color(0xFF3E2723),
                ),
                decoration: InputDecoration(
                  hintText: loc.editItemDetailsItemNameHint,
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                    color: const Color(0xFF795548).withValues(alpha: .5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
