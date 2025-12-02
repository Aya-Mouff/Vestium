import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()

class SettingsScreen1 extends StatefulWidget {
  final int userId;

  const SettingsScreen1({super.key, required this.userId});

  @override
  State<SettingsScreen1> createState() => _SettingsScreen1State();
}

class _SettingsScreen1State extends State<SettingsScreen1> with TickerProviderStateMixin {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool isEditing = false;

  String displayName = 'Sarah Johnson';
  String displayUsername = 'fashion_lover';
  String displayBio = 'Fashion enthusiast | Love creating new outfits';

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: displayName);
    usernameController = TextEditingController(text: displayUsername);
    bioController = TextEditingController(text: displayBio);
  }

  void _toggleEdit() {
    setState(() {
      if (isEditing) {
        nameController.text = displayName;
        usernameController.text = displayUsername;
        bioController.text = displayBio;
      }
      isEditing = !isEditing;
    });
  }

  void _saveChanges() {
    setState(() {
      displayName = nameController.text;
      displayUsername = usernameController.text;
      displayBio = bioController.text;
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7CCC8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'CormorantGaramond',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Container animated by content size
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  width: 380.29,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isEditing ? _buildEditMode() : _buildViewMode(),
                ),
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
                child: Text(
                  'ACCOUNT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF795548),
                    letterSpacing: 0.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Account Management',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
                child: Text(
                  'CATEGORIES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF795548),
                    letterSpacing: 0.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              _buildMenuItem(
                icon: Icons.grid_view_rounded,
                title: 'Manage Categories For Items',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                icon: Icons.grid_view_rounded,
                title: 'Manage Categories For Outfits',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
                child: Text(
                  'NOTIFICATIONS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF795548),
                    letterSpacing: 0.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              _buildToggleItem(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                value: pushNotifications,
                onChanged: (val) {
                  setState(() {
                    pushNotifications = val;
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildToggleItem(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                value: emailNotifications,
                onChanged: (val) {
                  setState(() {
                    emailNotifications = val;
                  });
                },
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
                child: Text(
                  'SUPPORT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF795548),
                    letterSpacing: 0.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),

              const SizedBox(height: 32),

              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xFFE74C3C),
                    size: 20,
                  ),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFFE74C3C),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewMode() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@$displayUsername',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF795548),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _toggleEdit,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF795548),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditMode() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF795548),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildField('Name', nameController, 'My Name'),
          const SizedBox(height: 16),
          _buildField('Username', usernameController, 'my_username'),
          const SizedBox(height: 16),
          _buildField('Bio', bioController, 'Fashion enthusiast ✨ | Style inspiration |', maxLines: 3),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _toggleEdit,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF795548),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF795548),
              fontFamily: 'Inter',
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD7CCC8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: Colors.black, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF795548)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD7CCC8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: Colors.black, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        trailing: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF795548),
            activeTrackColor: const Color(0xFF795548).withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }
}