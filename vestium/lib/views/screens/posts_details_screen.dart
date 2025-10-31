import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../widgets/nav_bar.dart';
import '../../data/dummy/dummy-data-loader.dart';

@RoutePage()
class PostsDetailsScreen extends StatefulWidget {
  final String postId;
  const PostsDetailsScreen({super.key, @PathParam('postId') required this.postId,});

  @override
  State<PostsDetailsScreen> createState() => _PostsDetailsScreenState();
}

class _PostsDetailsScreenState extends State<PostsDetailsScreen> {
  List<dynamic> myPosts = [];

  @override
  void initState() {
    super.initState();
    _loadMyPosts();
  }

  Future<void> _loadMyPosts() async {
    final data = await DummyDataLoader.loadDummyData();
    setState(() {
      // Filter posts for a specific user (e.g., userId '3' for trend_setter)
      myPosts = data['posts']
        .where((post) => post['userId'] == widget.postId) 
        .toList();
    });
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
      body: myPosts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: myPosts.length,
              itemBuilder: (context, index) {
                final post = myPosts[index];
                return _buildPostCard(post, context);
              },
            ),
      bottomNavigationBar: const CustomNavBar(currentPage: 'home'),
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
              post['imageUrl'],
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
                // Like, comment icons
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
                      onPressed: () {
                        context.router.pushNamed('/comments/${post['id']}');
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