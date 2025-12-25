import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordField({super.key, required this.controller, this.validator});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.fieldPasswordLabel,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B5344),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          cursorColor: const Color(0xFF6B5344),
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: loc.fieldPasswordHint,
            hintStyle: const TextStyle(
              fontFamily: 'inter',
              color: Color(0xFFA1887F),
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Color(0xFFA1887F),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Color(0xFFA1887F),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            filled: true,
            fillColor: const Color(0xFFF0EBE6),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFFD7CCC8), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFFD7CCC8), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}