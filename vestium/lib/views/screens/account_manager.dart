import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
@routePage
class AccountManagerScreen extends StatelessWidget {
  const AccountManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0ED),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Account Manager',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Change Email Card
            _buildAccountOptionCard(
              icon: Icons.email_outlined,
              iconColor: const Color(0xFF6B5B4F),
              title: 'Change Email',
              subtitle: 'Update your email address',
              onTap: () {
                print('Change Email tapped');
              },
            ),

            const SizedBox(height: 12),

            // Change Password Card
            _buildAccountOptionCard(
              icon: Icons.lock_outline,
              iconColor: const Color(0xFF6B5B4F),
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () {
                print('Change Password tapped');
              },
            ),

            const SizedBox(height: 12),

            // Change Full Name Card
            _buildAccountOptionCard(
              icon: Icons.person_outline,
              iconColor: const Color(0xFF6B5B4F),
              title: 'Change Full Name',
              subtitle: 'Update your display name',
              onTap: () {
                print('Change Full Name tapped');
              },
            ),

            const SizedBox(height: 24),

            // Danger Zone Label
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text(
                'DANGER ZONE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // Delete Account Card
            _buildAccountOptionCard(
              icon: Icons.delete_outline,
              iconColor: const Color(0xFFD32F2F),
              backgroundColor: const Color(0xFFFCE4E4),
              title: 'Delete Account',
              titleColor: const Color(0xFFD32F2F),
              subtitle: 'Permanently delete your account',
              subtitleColor: const Color(0xFFD32F2F).withOpacity(0.7),
              onTap: () {
                print('Delete Account tapped');
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAccountOptionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? titleColor,
    Color? subtitleColor,
  }) {
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
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor ?? Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Account',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFD32F2F),
            ),
          ),
          content: const Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Add delete account logic here
                print('Account deleted');
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}