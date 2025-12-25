import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/notifications_screen_cubit.dart';
import '../cubit/notifications_screen_state.dart';
import '../../../../app_router.dart';
import 'dart:io';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItemData item;
  final NotificationsCubit cubit;
  final int currentUserId;

  const NotificationItemWidget({super.key, required this.item, required this.cubit, required this.currentUserId});

  Widget _buildProfileImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage(imagePath),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback will be handled by CircleAvatar
        },
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundImage: FileImage(File(imagePath)),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback will be handled by CircleAvatar
        },
      );
    }
  }

  Widget _buildPostImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFE9D9CF),
            child: const Center(child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 20)),
          );
        },
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFE9D9CF),
            child: const Center(child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 20)),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5ECE7),
        border: Border(bottom: BorderSide(color: const Color(0x30795548), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image with gesture
            GestureDetector(
              onTap: () {
                context.router.push(UserProfileRoute(userId: item.sourceUserId, currentUserId: currentUserId));
              },
              child: Stack(
                children: [
                  _buildProfileImage(item.sourceProfileImage),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: cubit.getNotificationIconColor(item.type),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(cubit.getNotificationIcon(item.type), size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: item.sourceUsername,
                          style: const TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.router.push(
                                UserProfileRoute(userId: item.sourceUserId, currentUserId: currentUserId),
                              );
                            },
                        ),
                        TextSpan(
                          text: cubit.getNotificationText(item.type, loc, commentText: item.commentText),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cubit.getTimeAgo(item.createdAt, loc),
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (item.sourcePostId != null && item.sourcePostId!.isNotEmpty)
              FutureBuilder<String>(
                future: cubit.getPostImage(item.sourcePostId),
                builder: (context, snapshot) {
                  final imagePath = snapshot.data ?? 'assets/images/placeholder_post.png';
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xFFE9D9CF)),
                    child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _buildPostImage(imagePath)),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
