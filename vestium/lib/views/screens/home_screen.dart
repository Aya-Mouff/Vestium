import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../widgets/nav_bar.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> posts = const [
    {
      'id': '1',
      'username': 'fashionista_jane',
      'profileImage': 'assets/images/dummyData/profile-pic-women.jpg',
      'postImage': 'assets/images/dummyData/casual-weekend-outfit.jpg',
      'caption': 'Summer vibes 🌸',
      'likes': 234,
      'comments': 12,
    },
    {
      'id': '2',
      'username': 'style_maven',
      'profileImage': 'assets/images/dummyData/profile-pic-men.png',
      'postImage': 'assets/images/dummyData/urban-outfit-streetstyle-outfit.jpg',
      'caption': 'Urban exploration fit 🏙️',
      'likes': 156,
      'comments': 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      extendBody: true, // This makes the body extend behind the nav bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(
            'assets/images/logos/logo.png',
            width: 100,         
            height: 100, 
          ),  
        ),
        title: const Text(
          'Vestium',
          style: TextStyle(
            fontFamily: 'AlexBrush',
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCard(post);
        },
      ),
      bottomNavigationBar: const CustomNavBar(currentPage: 'home'),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // How much the shadow spreads
            blurRadius: 5,   // How soft the shadow is
            offset: Offset(3, 3), // Horizontal and vertical shadow position
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
                // Like and comment icons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border, size: 24),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mode_comment_outlined, size: 24),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),


                // Likes count
                Text(
                  '${post['likes']} likes',
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
                  'View all ${post['comments']} comments',
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