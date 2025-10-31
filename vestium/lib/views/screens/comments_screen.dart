import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../data/dummy/dummy-data-loader.dart';

@RoutePage()
class CommentsScreen extends StatefulWidget {
  final String postId;
  
  const CommentsScreen({
    super.key,
    @PathParam('postId') required this.postId,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<dynamic> comments = [];
  Map<String, dynamic>? currentUser;
  Map<String, dynamic>? usersMap;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    final data = await DummyDataLoader.loadDummyData();
    
    // Create a map of users for easy lookup
    Map<String, dynamic> userLookup = {};
    for (var user in data['users']) {
      userLookup[user['id']] = user;
    }
    
    // Find the post by ID
    final post = data['posts'].firstWhere(
      (p) => p['id'] == widget.postId,
      orElse: () => null,
    );

    // Get current user (user ID 1)
    final user = userLookup['1'];

    setState(() {
      comments = post?['comments'] ?? [];
      currentUser = user;
      usersMap = userLookup;
    });
  }

  String _getTimeAgo(String createdAt) {
    final dateTime = DateTime.parse(createdAt);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      comments.add({
        'id': (comments.length + 1).toString(),
        'userId': '1',
        'text': _commentController.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      });
    });

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'Comments',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Comments List
          Expanded(
            child: comments.isEmpty
                ? Center(
                    child: Text(
                      'No comments yet',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return _buildCommentItem(comment);
                    },
                  ),
          ),

          // Comment Input Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                      currentUser?['profileImage'] ?? 
                      'assets/images/dummyData/profile-pic-women.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        filled: true,
                        fillColor: Color(0x20D5CCC8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(36205500),
                          borderSide: BorderSide(color: Color(0x40795548), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(36205500),
                          borderSide: BorderSide(color: Color(0xFF795548), width: 2), // darker or main color on focus
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _addComment,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(0xFF795548),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCommentItem(Map<String, dynamic> comment) {
    final user = usersMap?[comment['userId']];
    final username = user?['username'] ?? 'unknown_user';
    final profileImage = user?['profileImage'] ?? 'assets/images/dummyData/profile-pic-women.jpg';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(profileImage),
          ),
          const SizedBox(width: 10),

          // Comment box + reply/time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // White rounded box (username + comment)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username
                      Text(
                        username,
                        style: const TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Comment text
                      Text(
                        comment['text'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Reply + time (below box)
                Row(
                  children: [
                    Text(
                      'Reply',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _getTimeAgo(comment['createdAt']),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


//   Widget _buildCommentItem(Map<String, dynamic> comment) {
//     final user = usersMap?[comment['userId']];
//     final username = user?['username'] ?? 'unknown_user';
//     final profileImage = user?['profileImage'] ?? 'assets/images/dummyData/profile-pic-women.jpg';

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // User info
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 16,
//                 backgroundImage: AssetImage(profileImage),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 username,
//                 style: const TextStyle(
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
          
//           // Comment text
//           Text(
//             comment['text'],
//             style: const TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 14,
//               color: Colors.black87,
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 10),
          
//           // Reply and time
//           Row(
//             children: [
//               Text(
//                 'Reply',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 12,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Text(
//                 _getTimeAgo(comment['createdAt']),
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 12,
//                   color: Colors.grey.shade500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
}