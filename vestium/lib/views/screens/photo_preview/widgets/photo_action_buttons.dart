import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/photo_preview_cubit.dart';
import '../cubit/photo_preview_state.dart';

class PhotoActionButtons extends StatelessWidget {
  final String imagePath;

  const PhotoActionButtons({super.key, required this.imagePath});

  void _retake(BuildContext context) {
    context.router.maybePop();
  }

  void _usePhoto(BuildContext context) async {
    final cubit = context.read<PhotoPreviewCubit>();
    cubit.setLoading(true);

    try {
      await context.router.push(EditItemRoute(imagePath: imagePath));
    } finally {
      cubit.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<PhotoPreviewCubit, PhotoPreviewState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              // Retake Button
              Expanded(
                child: OutlinedButton(
                  onPressed: state.isLoading ? null : () => _retake(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF795548),
                    side: const BorderSide(color: Color(0xFF795548), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    loc.photoPreviewRetake,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Use Photo Button
              Expanded(
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : () => _usePhoto(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
                    foregroundColor: const Color(0xFFFFFFFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFFFFF)),
                        )
                      : Text(
                          loc.photoPreviewUsePhoto,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
