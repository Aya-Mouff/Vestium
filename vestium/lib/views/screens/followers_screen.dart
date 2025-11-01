import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../app_router.dart';

@RoutePage()

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({Key? key}) : super(key: key);

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredFollowers = [];

  // Followers data from JSON - these are the followers of user "fashion_lover" (id: 1)
  // Followers array: ["2", "3"] which corresponds to style_guru and trend_setter
  final List<Map<String, dynamic>> followers = [
    {
      'id': '2',
      'name': 'Mike Chen',
      'username': 'style_guru',
      'bio': 'Street style photographer',
      'profileImage': 'assets/images/dummyData/profile-pic-men.png',
      'followersCount': 3,
      'followingCount': 1,
      'isFollowing': true, // fashion_lover follows style_guru back
    },
    {
      'id': '3',
      'name': 'Emma Davis',
      'username': 'trend_setter',
      'bio': 'Minimalist fashion | Sustainable clothing',
      'profileImage': 'assets/images/dummyData/profile-pic-women.jpg',
      'followersCount': 2,
      'followingCount': 3,
      'isFollowing': false, // fashion_lover follows trend_setter back
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredFollowers = List.from(followers);
    _searchController.addListener(_filterFollowers);
  }

  void _filterFollowers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredFollowers = List.from(followers);
      } else {
        filteredFollowers = followers.where((follower) {
          final name = follower['name'].toString().toLowerCase();
          final username = follower['username'].toString().toLowerCase();
          return name.contains(query) || username.contains(query);
        }).toList();
      }
    });
  }

  void toggleFollow(int index) {
    // Find the original index in the main followers list
    final followerToToggle = filteredFollowers[index];
    final originalIndex = followers
        .indexWhere((f) => f['id'] == followerToToggle['id']);

    setState(() {
      followers[originalIndex]['isFollowing'] = !followers[originalIndex]['isFollowing'];
      filteredFollowers[index]['isFollowing'] = followers[originalIndex]['isFollowing'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0ED),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Followers',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'CormorantGaramond',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            width: 381.26,
            height: 48,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
                const Icon(
                  Icons.search,
                  color: Color(0xFF795548),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search followers...',
                      hintStyle: TextStyle(
                        color: Color(0xFF795548),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Followers List
          Expanded(
            child: filteredFollowers.isEmpty && _searchController.text.isNotEmpty
                ? const Center(
                    child: Text(
                      'No followers found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF795548),
                        fontFamily: 'Inter',
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: filteredFollowers.length,
                    itemBuilder: (context, index) {
                      final follower = filteredFollowers[index];
                      return _buildFollowerItem(
                        name: follower['name'] ?? '',
                        username: follower['username'] ?? '',
                        profileImage: follower['profileImage'] ?? '',
                        isFollowing: follower['isFollowing'] ?? false,
                        onFollowTap: () => toggleFollow(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowerItem({
    required String name,
    required String username,
    required String profileImage,
    required bool isFollowing,
    required VoidCallback onFollowTap,
  }) {
    return Container(
      width: 381.26,
      height: 74.13,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF795548),
            backgroundImage: profileImage.isNotEmpty ? AssetImage(profileImage) : null,
            child: profileImage.isEmpty
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  )
                : null,
          ),

          const SizedBox(width: 12),

          // Name and Username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@$username',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF795548),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),

          // Follow/Following Button
          InkWell(
            onTap: onFollowTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: isFollowing ? 95.83 : 73.34,
              height: 35.99,
              decoration: BoxDecoration(
                color: isFollowing ? Colors.transparent : const Color(0xFF795548),
                border: Border.all(
                  color: const Color(0xFF795548),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  isFollowing ? 'Following' : 'Follow',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isFollowing ? const Color(0xFF795548) : Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

