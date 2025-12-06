import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/repo/user_repo.dart';
import 'package:vestium/views/screens/account_manager/cubit/account_manager_cubit.dart';
import 'package:vestium/views/screens/account_manager/widgets/change_email_dialog.dart';
import 'package:vestium/views/screens/account_manager/widgets/change_fullname_dialog.dart';
import 'package:vestium/views/screens/account_manager/widgets/change_password_dialog.dart';
import 'package:vestium/views/screens/account_manager/widgets/delete_account_dialog.dart';

class AccountManagerScreen extends StatefulWidget {
  const AccountManagerScreen({Key? key}) : super(key: key);

  @override
  State<AccountManagerScreen> createState() => _AccountManagerScreenState();
}

class _AccountManagerScreenState extends State<AccountManagerScreen> {
  late AccountManagerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AccountManagerCubit(userRepo: UserRepo());
    _cubit.loadUserData();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountManagerCubit>.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Account Settings'), elevation: 0),
        body: BlocBuilder<AccountManagerCubit, AccountManagerState>(
          builder: (context, state) {
            // Loading state
            if (state is AccountManagerLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Loaded or Updating state
            if (state is AccountManagerLoaded ||
                state is AccountManagerUpdating) {
              final user = state is AccountManagerLoaded
                  ? state.user
                  : (state as AccountManagerUpdating).user;

              final isUpdating = state is AccountManagerUpdating;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'User Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _InfoRow(
                              label: 'Full Name',
                              value: user.fullName ?? 'Not set',
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              label: 'Email',
                              value: user.email ?? 'Not set',
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(label: 'User ID', value: '${user.userId}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Settings Section
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingButton(
                      label: 'Change Full Name',
                      icon: Icons.person,
                      onPressed: isUpdating
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => ChangeFullNameDialog(
                                  currentName: user.fullName ?? '',
                                ),
                              );
                            },
                    ),
                    const SizedBox(height: 12),
                    _SettingButton(
                      label: 'Change Email',
                      icon: Icons.email,
                      onPressed: isUpdating
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => ChangeEmailDialog(
                                  currentEmail: user.email ?? '',
                                ),
                              );
                            },
                    ),
                    const SizedBox(height: 12),
                    _SettingButton(
                      label: 'Change Password',
                      icon: Icons.lock,
                      onPressed: isUpdating
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const ChangePasswordDialog(),
                              );
                            },
                    ),
                    const SizedBox(height: 24),
                    // Danger Zone
                    const Text(
                      'Danger Zone',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingButton(
                      label: 'Delete Account',
                      icon: Icons.delete_forever,
                      isDangerous: true,
                      onPressed: isUpdating
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    const DeleteAccountDialog(),
                              );
                            },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }

            // Error state
            if (state is AccountManagerError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _cubit.loadUserData(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Initial state
            return Center(
              child: ElevatedButton.icon(
                onPressed: () => _cubit.loadUserData(),
                icon: const Icon(Icons.refresh),
                label: const Text('Load User Data'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _SettingButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDangerous;

  const _SettingButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: isDangerous ? Colors.red : null),
        label: Text(
          label,
          style: TextStyle(color: isDangerous ? Colors.red : null),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: isDangerous ? Colors.red : Colors.grey),
        ),
      ),
    );
  }
}
