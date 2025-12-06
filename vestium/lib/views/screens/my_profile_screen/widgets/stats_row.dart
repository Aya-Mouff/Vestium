import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../app_router.dart';

class StatsRow extends StatelessWidget {
  final int outfitsCount;
  final int followers;
  final int following;
  final int postsCount;
  final int userId;
  
  const StatsRow({
    super.key, 
    required this.outfitsCount, 
    required this.followers, 
    required this.following,
    required this.postsCount,
    required this.userId
  });

  Widget _buildStat(BuildContext context, String label, int value) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value.toString(), 
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: TextButton(
              onPressed: () {
                if (label == "Followers") {
                  context.pushRoute(FollowersRoute(userId: userId, currentUserId: userId));
                } else if (label == "Following") {
                  context.pushRoute(FollowingRoute(userId: userId, currentUserId: userId));
                }
                // Posts and Outfits don't have navigation
              }, 
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                label, 
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to adjust layout
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16), // Reduced margin
      padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), // Slightly smaller radius
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use different layout for very small screens
          if (screenWidth < 350) {
            return Column(
              children: [
                // First row: Posts and Outfits
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat(context, 'Posts', postsCount),
                    _buildStat(context, 'Outfits', outfitsCount),
                  ],
                ),
                const SizedBox(height: 12),
                // Second row: Followers and Following
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat(context, 'Followers', followers),
                    _buildStat(context, 'Following', following),
                  ],
                ),
              ],
            );
          } else {
            // Normal layout for wider screens
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat(context, 'Posts', postsCount),
                _buildStat(context, 'Outfits', outfitsCount),
                _buildStat(context, 'Followers', followers),
                _buildStat(context, 'Following', following),
              ],
            );
          }
        },
      ),
    );
  }
}