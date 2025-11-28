import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
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

    return BlocProvider(
      create: (_) => NotificationsCubit()..loadNotifications(userId!),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => context.router.pop()),
          title: const Text('Notifications', style: TextStyle(fontFamily: 'CormorantGaramond', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87)),
          centerTitle: true,
        ),
        body: 
           userId == -1
          ? const AccessDeniedScreen()   // If user is not logged in
          : 
          BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) return const Center(child: CircularProgressIndicator());
            if (state is NotificationsError) return Center(child: Text(state.message));
            if (state is NotificationsLoaded) return NotificationsListWidget(notifications: state.notifications, cubit: context.read<NotificationsCubit>());
            return const SizedBox();
          },
        ),
        bottomNavigationBar: CustomNavBar(currentPage: 'home', userId: userId!),
      ),
    );
  }
}
