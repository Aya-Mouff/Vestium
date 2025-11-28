import 'package:flutter/material.dart';

class CommentInputField extends StatelessWidget {
  final bool canComment;
  final Function(String text) onSend;
  final dynamic currentUser;

  const CommentInputField({
    super.key,
    required this.canComment,
    required this.onSend,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    if (!canComment) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: const Text(
          "You must be logged in to comment",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                currentUser?["profileImage"] ??
                'assets/images/dummyData/profile-pic-women.jpg',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  filled: true,
                  fillColor: const Color(0x20D5CCC8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36205500),
                    borderSide: const BorderSide(color: Color(0x40795548), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36205500),
                    borderSide: const BorderSide(color: Color(0xFF795548), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
                maxLines: null,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                if (controller.text.trim().isNotEmpty) {
                  onSend(controller.text.trim());
                  controller.clear();
                }
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF795548),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, size: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
