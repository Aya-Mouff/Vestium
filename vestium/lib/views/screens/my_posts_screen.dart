import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../widgets/nav_bar.dart';

@RoutePage()
class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  final List<Map<String, dynamic>> myPosts = const [
    {
      'id': '1',
      'username': 'fashionista_jane',
      'profileImage': 'assets/images/dummyData/profile-pic-women.jpg',
      'postImage': 'assets/images/dummyData/casual-weekend-outfit.jpg',
      'caption': 'Summer vibes 🌸',
      "likesCount": 234,
      "commentsCount": 12
    },
    {
      'id': '1',
      'username': 'fashionista_jane',
      'profileImage': 'assets/images/dummyData/profile-pic-women.jpg',
      'postImage': "assets/images/dummyData/urban-outfit-streetstyle-outfit.jpg",
      'caption': 'Urban exploration fit 🏙️',
      "likesCount": 189,
      "commentsCount": 8
    }
  ];

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Delete Post?',
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to delete this post?\nThis action cannot be undone and the post\nwill be removed from your profile.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Delete button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle delete logic here
                      Navigator.of(context).pop();
                      // You can add a snackbar or other feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post deleted'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE7000B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Cancel button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            context.router.pop();
          },
        ),
        title: const Text(
          'Posts',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: myPosts.length,
        itemBuilder: (context, index) {
          final post = myPosts[index];
          return _buildPostCard(post, context);
        },
      ),
      bottomNavigationBar: const CustomNavBar(currentPage: 'profile'),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(post['profileImage']),
                ),
                const SizedBox(width: 12),
                Text(
                  post['username'],
                  style: const TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Post image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
            child: Image.asset(
              post['postImage'],
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),

          // Action buttons and stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Like, comment icons and delete button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite, size: 24, color: Colors.red),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.mode_comment_outlined, size: 24),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Spacer(),
                    // 
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 24, color: Colors.red),
                      onPressed: () {
                        _showDeleteDialog(context, post);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Likes count
                Text(
                  '${post['likesCount']} likes',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                // Caption
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${post['username']} ',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: post['caption'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // View comments
                Text(
                  'View all ${post['commentsCount']} comments',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}