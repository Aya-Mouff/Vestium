import 'package:flutter/material.dart';

class DeletePostDialog extends StatelessWidget {
  final VoidCallback onDeletePressed;
  final VoidCallback onCancelPressed;

  const DeletePostDialog({
    super.key,
    required this.onDeletePressed,
    required this.onCancelPressed,
  });

  static Future<bool?> show(
    BuildContext context, {
    required VoidCallback onDeletePressed,
    required VoidCallback onCancelPressed,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return DeletePostDialog(
          onDeletePressed: onDeletePressed,
          onCancelPressed: onCancelPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            const SizedBox(height: 16),
            _buildDescription(),
            const SizedBox(height: 24),
            _buildDeleteButton(),
            const SizedBox(height: 12),
            _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Delete Post?',
      style: TextStyle(
        fontFamily: 'CormorantGaramond',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Are you sure you want to delete this post?\nThis action cannot be undone and the post\nwill be removed from your profile.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: Colors.grey.shade700,
        height: 1.5,
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onDeletePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE7000B),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Delete',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onCancelPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          'Cancel',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}