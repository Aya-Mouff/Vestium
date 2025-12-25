import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../../../../app_router.dart';
import 'package:auto_route/auto_route.dart';

class UserStats extends StatelessWidget {
  final int posts;
  final int followers;
  final int following;
  final int userId;
  final int currentUserId;

  const UserStats({
    super.key,
    required this.posts,
    required this.followers,
    required this.following,
    required this.userId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _item(context, "Posts", posts),
          _item(context, "Followers", followers),
          _item(context, "Following", following),
        ],
      ),
    );
  }

  Column _item(BuildContext context, String label, int value) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        if (label == "Followers")
          TextButton(
            onPressed: () {
              context.router.push(FollowersRoute(userId: userId, currentUserId: currentUserId));
            },
            child: Text(loc.userProfileFollowersLabel, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ),
        if (label == "Following")
          TextButton(
            onPressed: () {
              context.router.push(FollowingRoute(userId: userId, currentUserId: currentUserId));
            },
            child: Text(loc.userProfileFollowingLabel, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ),
        if (label == "Posts")
          TextButton(
            onPressed: () {},
            child: Text(loc.userProfilePostsLabel, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ),
      ],
    );
  }
}
