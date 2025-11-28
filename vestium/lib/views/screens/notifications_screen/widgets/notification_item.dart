import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../cubit/notifications_screen_cubit.dart';
import '../cubit/notifications_screen_state.dart';
import '../../../../app_router.dart'; // Make sure your routes are imported

class NotificationItemWidget extends StatelessWidget {
  final NotificationItemData item;
  final NotificationsCubit cubit;

  const NotificationItemWidget({
    super.key,
    required this.item,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5ECE7),
        border: Border(bottom: BorderSide(color: Color(0x30795548), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image with gesture
            GestureDetector(
              onTap: () {
                context.router.push(UserProfileRoute(userId: item.sourceUserId)); // Navigate to user profile
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(item.sourceProfileImage),
                  ),
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
                      child: Icon(cubit.getNotificationIcon(item.type),
                          size: 12, color: Colors.white),
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
                              color: Colors.black),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.router.push(UserProfileRoute(userId: item.sourceUserId));
                            },
                        ),
                        TextSpan(
                          text: cubit.getNotificationText(item.type),
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cubit.getTimeAgo(item.createdAt),
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (item.sourcePostId != null && item.sourcePostId!.isNotEmpty)
              Container(
                width: 50,
                height: 50,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade300),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(cubit.getPostImage(item.sourcePostId),
                      fit: BoxFit.cover),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
