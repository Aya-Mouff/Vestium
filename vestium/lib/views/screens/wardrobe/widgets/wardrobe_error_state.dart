// lib/wardrobe_screen/widgets/wardrobe_error_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/wardrobe_cubit.dart';

class WardrobeErrorState extends StatelessWidget {
  final String errorMessage;

  const WardrobeErrorState({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<WardrobeCubit>().refresh(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B6B61)),
            child: Builder(
              builder: (context) {
                final loc = AppLocalizations.of(context)!;
                return Text(loc.wardrobeErrorRetry, style: const TextStyle(color: Colors.white));
              },
            ),
          ),
        ],
      ),
    );
  }
}
