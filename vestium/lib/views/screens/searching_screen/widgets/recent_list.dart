import 'package:flutter/material.dart';

class RecentList extends StatelessWidget {
  final List<String> recentUsers;
  final void Function(String username) onTapRecent;
  final void Function(int index) onRemoveRecent;
  final VoidCallback onClearAll;

  const RecentList({
    super.key,
    required this.recentUsers,
    required this.onTapRecent,
    required this.onRemoveRecent,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentUsers.length,
            itemBuilder: (context, index) {
              final username = recentUsers[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => onTapRecent(username),
                  child: Container(
                    height: 50.1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD7CCC8),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: Color(0xFF795548),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              username,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => onRemoveRecent(index),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Color(0xFF795548),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Color(0xFF795548)),
              SizedBox(width: 8),
              Text(
                'Recent',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onClearAll,
            child: const Text(
              'Delete all',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF795548),
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
