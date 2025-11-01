import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../app_router.dart';

@RoutePage()

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredFollowing = [];

  // Data from JSON file - users with id=2 and id=4
  final List<Map<String, dynamic>> following = [
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
      'id': '4',
      'name': 'Alex Rodriguez',
      'username': 'urban_style',
      'bio': 'Urban fashion lover',
      'profileImage': 'assets/images/dummyData/profile-pic-men.png',
      'followersCount': 2,
      'followingCount': 2,
      'isFollowing': true, // fashion_lover follows urban_style back
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredFollowing = List.from(following);
    _searchController.addListener(_filterFollowing);
  }

  void _filterFollowing() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredFollowing = List.from(following);
      } else {
        filteredFollowing = following.where((person) {
          final name = person['name'].toString().toLowerCase();
          final username = person['username'].toString().toLowerCase();
          return name.contains(query) || username.contains(query);
        }).toList();
      }
    });
  }

  void toggleFollow(int index) {
    // Find the original index in the main following list
    final personToToggle = filteredFollowing[index];
    final originalIndex =
        following.indexWhere((f) => f['id'] == personToToggle['id']);

    setState(() {
      following[originalIndex]['isFollowing'] = !following[originalIndex]['isFollowing'];
      filteredFollowing[index]['isFollowing'] = following[originalIndex]['isFollowing'];
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Following',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
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
                Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search following...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
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

          // Following List
          Expanded(
            child: filteredFollowing.isEmpty && _searchController.text.isNotEmpty
                ? Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: 'Inter',
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: filteredFollowing.length,
                    itemBuilder: (context, index) {
                      final person = filteredFollowing[index];
                      return _buildFollowingItem(
                        name: person['name'] ?? '',
                        username: person['username'] ?? '',
                        profileImage: person['profileImage'] ?? '',
                        isFollowing: person['isFollowing'] ?? false,
                        onFollowTap: () => toggleFollow(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingItem({
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
            backgroundColor: const Color(0xFF8B6F5E),
            backgroundImage: AssetImage(profileImage),
            child: profileImage.isEmpty
                ? Text(
                    name[0].toUpperCase(),
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
                    color: Color(0xFF2C2C2C),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@$username',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
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
                color: isFollowing ? Colors.transparent : const Color(0xFF8B6F5E),
                border: Border.all(
                  color: isFollowing ? Colors.grey[300]! : const Color(0xFF8B6F5E),
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
                    color: isFollowing ? Colors.grey[700] : Colors.white,
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