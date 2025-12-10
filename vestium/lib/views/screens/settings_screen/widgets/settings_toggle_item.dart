import 'package:flutter/material.dart';

class SettingsToggleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: const Color(0xFF3E2723),
          size: 22,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E2723),
            fontFamily: 'Inter',
          ),
        ),
        trailing: Switch(
          value: value,
          activeThumbColor: const Color(0xFF795548),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
