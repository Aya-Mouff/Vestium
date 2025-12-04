import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(user['pfp'] ?? 'assets/images/icons/person.jpg'),
        ),
        const SizedBox(height: 12),
        Text(
          user['full_name'] ?? '',
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          user['bio'] ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }
}
