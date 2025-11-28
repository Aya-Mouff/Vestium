import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/dummy/dummy-data-loader.dart';
import 'notifications_screen_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  Future<void> loadNotifications(int userId) async {
    if (userId == -1) return; // Access denied handled in UI
    try {
      emit(NotificationsLoading());

      final data = await DummyDataLoader.loadDummyData();
      final rawNotifications = data['notifications'] as List<dynamic>;

      // Map directly to NotificationItemData while filtering
      final notifications = rawNotifications
          .where((n) => n['userId'].toString() == userId.toString())
          .map<NotificationItemData>((n) => NotificationItemData(
                sourceUsername: n['sourceUsername'] ?? 'User',
                sourceUserId: int.parse(n['sourceUserId'].toString()),
                sourceProfileImage: n['sourceProfileImage'] ??
                    'assets/images/dummyData/profile-pic-women.jpg',
                type: n['type'] ?? '',
                createdAt: n['createdAt'] ??
                    DateTime.now().toIso8601String(), // fallback if missing
                sourcePostId: n['sourcePostId'],
              ))
          .toList();

      // Emit proper typed list
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  String getTimeAgo(String createdAt) {
    final dateTime = DateTime.parse(createdAt);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  IconData getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.mode_comment;
      case 'follow':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Color getNotificationIconColor(String type) {
    switch (type) {
      case 'like':
        return Colors.red;
      case 'comment':
        return Colors.blue;
      case 'follow':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getPostImage(String? postId) {
    // In real app, fetch the post image by postId
    return postId != null
        ? 'assets/images/dummyData/casual-weekend-outfit.jpg'
        : '';
  }

  String getNotificationText(String type) {
    switch (type) {
      case 'like':
        return ' liked your outfit';
      case 'comment':
        return ' commented: "Love this look! 🔥"';
      case 'follow':
        return ' started following you';
      default:
        return ' interacted with your content';
    }
  }
}
