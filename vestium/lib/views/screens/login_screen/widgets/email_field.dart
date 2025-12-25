import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const EmailField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.loginEmailLabel,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B5344),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          cursorColor: const Color(0xFF6B5344),
          decoration: InputDecoration(
            hintText: loc.loginEmailHint,
            hintStyle: const TextStyle(
              fontFamily: 'inter',
              color: Color(0xFFA1887F),
            ),
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Color(0xFFA1887F),
            ),
            filled: true,
            fillColor: const Color(0xFFF0EBE6),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: Color(0xFFD7CCC8), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: Color(0xFFD7CCC8), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: validator,
        ),
      ],
    );
  }
}
