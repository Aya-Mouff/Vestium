import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../../widgets/nav_bar.dart';
import 'cubit/notifications_screen_cubit.dart';
import 'cubit/notifications_screen_state.dart';
import 'widgets/notifications_list.dart';
import '../access_denied.dart';

@RoutePage()
class NotificationsScreen extends StatelessWidget {
  final int? userId;
  const NotificationsScreen({super.key, @PathParam('userId') required this.userId});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => NotificationsCubit()..loadNotifications(userId!),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.router.pop(),
          ),
          title: Text(
            loc.notificationsTitle,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: userId == -1
            ? const AccessDeniedScreen()
            : BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is NotificationsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<NotificationsCubit>().loadNotifications(userId!),
                            child: Text(loc.notificationsRetry),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is NotificationsLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<NotificationsCubit>().loadNotifications(userId!);
                      },
                      color: const Color(0xFF7B5247),
                      backgroundColor: const Color(0xFFF5ECE7),
                      child: NotificationsListWidget(
                        notifications: state.notifications,
                        cubit: context.read<NotificationsCubit>(),
                        currentUserId: userId!,
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
        bottomNavigationBar: CustomNavBar(currentPage: 'home', userId: userId!),
      ),
    );
  }
}
