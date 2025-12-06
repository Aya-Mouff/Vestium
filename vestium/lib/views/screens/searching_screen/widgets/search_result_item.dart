import 'package:flutter/material.dart';

class SearchResultItem extends StatelessWidget {
  final Map<String, dynamic> user;
  final int currentUserId; // Add this parameter
  final VoidCallback onTapUser;
  final VoidCallback onToggleFollow;

  const SearchResultItem({
    super.key,
    required this.user,
    required this.currentUserId, // Add this
    required this.onTapUser,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    final isFollowing = user['isFollowing'] == true;
    final userId = user['userId'] as int? ?? int.tryParse(user['id'].toString()) ?? 0;
    final isCurrentUser = userId == currentUserId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTapUser,
        child: Container(
          height: 80.09,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD7CCC8),
              width: 1,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFF795548),
                  backgroundImage:
                      (user['profileImage'] as String).isNotEmpty
                          ? AssetImage(user['profileImage'] as String)
                          : null,
                  child: (user['profileImage'] as String).isEmpty
                      ? Text(
                          (user['username'] as String)
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user['username'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user['fullName'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF795548),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Only show follow button if it's not the current user
                if (!isCurrentUser)
                  GestureDetector(
                    onTap: onToggleFollow,
                    child: Container(
                      width: 72.39,
                      height: 27.97,
                      decoration: BoxDecoration(
                        color: isFollowing
                            ? Colors.transparent
                            : const Color(0xFF795548),
                        borderRadius: BorderRadius.circular(20),
                        border: isFollowing
                            ? Border.all(
                                color: const Color(0xFF795548),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          isFollowing ? 'Following' : 'Follow',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isFollowing
                                ? const Color(0xFF795548)
                                : Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}