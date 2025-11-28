import 'package:flutter/material.dart';
import '../cubit/notifications_screen_cubit.dart';
import '../cubit/notifications_screen_state.dart';
import 'notification_item.dart';

class NotificationsListWidget extends StatelessWidget {
  final List<NotificationItemData> notifications;
  final NotificationsCubit cubit;

  const NotificationsListWidget({super.key, required this.notifications, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationItemWidget(item: notifications[index], cubit: cubit);
      },
    );
  }
}
