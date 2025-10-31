import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../widgets/nav_bar.dart';
import '../../data/dummy/dummy-data-loader.dart';

@RoutePage()
class UserProfileScreen extends StatefulWidget {
  final String userId; // ID of the user whose profile we want to show
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? user;
  List<dynamic> posts = [];
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await DummyDataLoader.loadDummyData();
    final users = data['users'] as List<dynamic>;
    final postsData = data['posts'] as List<dynamic>;

    // Find the user by the provided userId
    final selectedUser = users.firstWhere(
      (u) => u['id'].toString() == widget.userId,
      orElse: () => null,
    );

    if (selectedUser == null) return;

    // Filter posts of this user
    final userPosts = postsData
        .where((p) => p['userId'].toString() == widget.userId)
        .toList();

    setState(() {
      user = selectedUser;
      posts = userPosts;
      isFollowing = false; // Replace with actual follow status if needed
    });
  }

  void _toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          user!['username'],
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Profile picture
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(user!['profileImage']),
            ),
            const SizedBox(height: 12),
            // Full name
            Text(
              user!['fullName'],
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Bio
            Text(
              user!['bio'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            // Stats
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('Posts', posts.length.toString()),
                  _buildStat('Followers', user!['followersCount'].toString()),
                  _buildStat('Following', user!['followingCount'].toString()),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Follow / Following button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: _toggleFollow,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFollowing ? Colors.white : const Color(0xFF795548),
                  side: isFollowing
                      ? const BorderSide(color: Colors.grey)
                      : BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: Text(
                  isFollowing ? 'Following' : 'Follow',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isFollowing ? Colors.black87: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Posts grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildPostsGrid(),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentPage: 'home'),
    );
  }

  Widget _buildPostsGrid() {
    if (posts.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No posts yet',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            context.router.pushNamed(
              '/posts_details/${post['id']}',
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              post['imageUrl'],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
