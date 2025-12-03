import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
//import '../cubit/outfit_details_cubit.dart';
import 'delete_outfit_dialog.dart';

class OutfitActionButtons extends StatelessWidget {
  const OutfitActionButtons({super.key});

  void _shareOutfit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality - Coming soon'),
        backgroundColor: Color(0xFF795548),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteOutfitDialog(
          onDelete: () {
            Navigator.of(context).pop();
            context.router.maybePop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Outfit deleted'),
                backgroundColor: Color(0xFF795548),
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Share Button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _shareOutfit(context),
              icon: const Icon(Icons.share_outlined, size: 20),
              label: const Text(
                'Share Outfit',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 0.3,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF795548),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Delete Button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _showDeleteDialog(context),
              icon: const Icon(Icons.delete_outline, size: 20),
              label: const Text(
                'Delete Outfit',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 0.3,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE7000B),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}