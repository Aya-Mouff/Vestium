import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../app_router.dart';

class StatsRow extends StatelessWidget {
  final int outfitsCount;
  final int followers;
  final int following;
  final int userId;
  const StatsRow({super.key, required this.outfitsCount, required this.followers, required this.following, required this.userId});

  Widget _buildStat(BuildContext context, String label, int value) {
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        if (label == "Followers")
          TextButton(onPressed: () {context.pushRoute(FollowersRoute(userId: userId));}, child: Text(label, style: const TextStyle(color: Colors.black54) )),
        if (label == "Following")
          TextButton(onPressed: () {context.pushRoute(FollowingRoute(userId: userId));}, child: Text(label, style: const TextStyle(color: Colors.black54) )),
        if (label == "Outfits")
          TextButton(onPressed: () {}, child: Text(label, style: const TextStyle(color: Colors.black54) )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStat(context, 'Outfits', outfitsCount),
          _buildStat(context, 'Followers', followers),
          _buildStat(context, 'Following', following),
        ],
      ),
    );
  }
}
