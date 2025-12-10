import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/views/screens/account_manager/cubit/account_manager_cubit.dart';
import 'package:vestium/views/screens/account_manager/cubit/account_manager_state.dart';
import 'package:vestium/views/screens/account_manager/widgets/change_email_dialog.dart';
import 'package:vestium/views/screens/account_manager/widgets/change_password_dialog.dart';
import 'package:vestium/views/screens/account_manager/widgets/change_full_name_dialog.dart';
import 'package:vestium/views/screens/account_manager/widgets/delete_account_dialog.dart';

@RoutePage()
class AccountManagerScreen extends StatelessWidget {
  final int userId;

  const AccountManagerScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.router.replace(const AccessDeniedRoute());
      });
      return const SizedBox();
    }

    return BlocProvider(
      create: (_) => AccountManagerCubit(userId: userId)..init(),
      child: const _AccountManagerView(),
    );
  }
}

class _AccountManagerView extends StatelessWidget {
  const _AccountManagerView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountManagerCubit, AccountManagerState>(
      listener: (context, state) {
        if (state.message == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.message!,
              style: const TextStyle(
                fontFamily: 'inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF6B5344),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      },
      builder: (context, state) {
        final isLoading = state.status == AccountManagerStatus.loading;

        return Scaffold(
          backgroundColor: const Color(0xFFF5ECE7),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: const Color(0xFF2C2C2C),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Account Manager',
              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                color: Color(0xFF2C2C2C),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Change Email
                    _AccountOptionCard(
                      icon: Icons.email_outlined,
                      iconColor: const Color(0xFF6B5B4F),
                      title: 'Change Email',
                      subtitle: 'Update your email address',
                      onTap: () => showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<AccountManagerCubit>(),
                          child: const ChangeEmailDialog(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Change Password
                    _AccountOptionCard(
                      icon: Icons.lock_outline,
                      iconColor: const Color(0xFF6B5B4F),
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      onTap: () => showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<AccountManagerCubit>(),
                          child: const ChangePasswordDialog(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Change Full Name
                    _AccountOptionCard(
                      icon: Icons.person_outline,
                      iconColor: const Color(0xFF6B5B4F),
                      title: 'Change Full Name',
                      subtitle: 'Update your display name',
                      onTap: () => showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<AccountManagerCubit>(),
                          child: const ChangeFullNameDialog(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                      child: Text(
                        'DANGER ZONE',
                        style: TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    _AccountOptionCard(
                      icon: Icons.delete_outline,
                      iconColor: const Color(0xFFD32F2F),
                      backgroundColor: const Color(0xFFFCE4E4),
                      title: 'Delete Account',
                      titleColor: const Color(0xFFD32F2F),
                      subtitle: 'Permanently delete your account',
                      subtitleColor: const Color(0xFFD32F2F).withOpacity(0.7),
                      onTap: () => showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<AccountManagerCubit>(),
                          child: const DeleteAccountDialog(),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Small reusable card widget (kept local to this file)
class _AccountOptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const _AccountOptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: 13,
                      color: subtitleColor ?? Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}
