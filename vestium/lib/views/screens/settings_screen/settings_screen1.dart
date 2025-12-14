import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_router.dart';
import '../../../../repo/user_repo.dart';
import 'cubit/settings_cubit.dart';
import 'cubit/settings_state.dart';
import 'widgets/profile_view_mode.dart';
import 'widgets/profile_edit_mode.dart';
import 'widgets/settings_menu_item.dart';
import 'widgets/settings_toggle_item.dart';
import 'widgets/settings_section_header.dart';

@RoutePage()
class SettingsScreen1 extends StatefulWidget {
  final int userId;

  const SettingsScreen1({super.key, @PathParam('userId') required this.userId});

  @override
  State<SettingsScreen1> createState() => _SettingsScreen1State();
}

class _SettingsScreen1State extends State<SettingsScreen1> {
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _syncControllers(SettingsState state) {
    // Always sync when entering edit mode or when values change
    _nameController.text = state.displayName;
    _usernameController.text = state.displayUsername;
    _bioController.text = state.displayBio;
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = context.read<UserRepo>();

    return BlocProvider(
      create: (_) => SettingsCubit(userRepo, userId: widget.userId),
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          // Sync controllers whenever we enter edit mode
          if (state.isEditing) {
            // Use addPostFrameCallback to ensure controllers are synced after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _syncControllers(state);
            });
          }

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }

          if (state.saveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated')),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();

          return Scaffold(
            backgroundColor: const Color(0xFFF2E7E0),
            appBar: AppBar(
              title: const Text(
                'Settings',
                style: TextStyle(
                  color: Color(0xFF3E2723),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: const Color(0xFFF2E7E0),
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
            ),
            body: state.isLoading && !state.isEditing
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile card (view/edit)
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.white,
                          child: state.isEditing
                              ? ProfileEditMode(
                                  profileImage: state.profileImage,
                                  nameController: _nameController,
                                  usernameController: _usernameController,
                                  bioController: _bioController,
                                  onCancel: cubit.cancelEdit,
                                  onSave: () {
                                    cubit.saveChanges(
                                      _nameController.text.trim(),
                                      _usernameController.text.trim(),
                                      _bioController.text.trim(),
                                    );
                                  },
                                  onImagePick: cubit.pickProfileImage,
                                )
                              : ProfileViewMode(
                                  displayName: state.displayName,
                                  displayUsername: state.displayUsername,
                                  profileImage: state.profileImage,
                                  onEdit: cubit.toggleEdit,
                                ),
                        ),
                        const SizedBox(height: 24),

                        // ACCOUNT
                        const SettingsSectionHeader(title: 'ACCOUNT'),
                        SettingsMenuItem(
                          icon: Icons.person_outline,
                          title: 'Account Management',
                          onTap: () {
                            context.router.push(
                              AccountManagerRoute(userId: widget.userId),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // CATEGORIES
                        const SettingsSectionHeader(title: 'CATEGORIES'),
                        SettingsMenuItem(
                          icon: Icons.category_outlined,
                          title: 'Manage Categories For Items',
                          onTap: () {
                            context.router.push(
                              ManageCategoriesRoute(),
                            );
                           // TODO: Navigate to items categories screen
                          },
                        ),
                        const SizedBox(height: 12),
                        SettingsMenuItem(
                          icon: Icons.checkroom_outlined,
                          title: 'Manage Categories For Outfits',
                          onTap: () {
                            context.router.push(
                              ManageOutfitCategoriesRoute(userId: widget.userId),
                            );
                           // TODO: Navigate to outfits categories screen
                          },
                        ),
                        const SizedBox(height: 24),

                        // NOTIFICATIONS
                        const SettingsSectionHeader(title: 'NOTIFICATIONS'),
                        SettingsToggleItem(
                          icon: Icons.notifications_active_outlined,
                          title: 'Push Notifications',
                          value: state.pushNotifications,
                          onChanged: cubit.togglePushNotifications,
                        ),
                        const SizedBox(height: 12),
                        SettingsToggleItem(
                          icon: Icons.email_outlined,
                          title: 'Email Notifications',
                          value: state.emailNotifications,
                          onChanged: cubit.toggleEmailNotifications,
                        ),
                        const SizedBox(height: 24),

                        // SUPPORT
                        const SettingsSectionHeader(title: 'SUPPORT'),
                        SettingsMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help Center',
                          onTap: () {
                           context.router.push(
                              HelpCenterRoute(),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // LOG OUT
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Text('Log out'),
                                    content: const Text(
                                      'Are you sure you want to log out?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(true),
                                        child: const Text(
                                          'Log out',
                                          style: TextStyle(
                                            color: Color(0xFFD32F2F),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmed == true) {
                                await cubit.logout(context);
                              }
                            },
                            child: const Text(
                              'Log Out',
                              style: TextStyle(
                                color: Color(0xFFD32F2F),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}