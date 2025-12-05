import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifications_screen_state.dart';
import '../../../../repo/like_repo.dart';
import '../../../../repo/comment_repo.dart';
import '../../../../repo/follow_repo.dart';
import '../../../../repo/post_repo.dart';
import '../../../../repo/user_repo.dart';
import '../../../../databases/db_models.dart';
import '../../../../databases/services/user_profile_service.dart';
import 'dart:io';

class NotificationsCubit extends Cubit<NotificationsState> {
  final LikeRepo _likeRepo = LikeRepo();
  final CommentRepo _commentRepo = CommentRepo();
  final FollowRepo _followRepo = FollowRepo();
  final PostRepo _postRepo = PostRepo();
  final UserRepo _userRepo = UserRepo();

  NotificationsCubit() : super(NotificationsInitial());

  Future<void> loadNotifications(int userId) async {
    if (userId == -1) return;
    
    try {
      emit(NotificationsLoading());

      // 1. Fetch all notifications from different sources
      final List<NotificationItemData> allNotifications = [];

      // Get user's posts to find notifications related to them
      final userPosts = await _postRepo.getByUserId(userId);

      // 2. Fetch likes on user's posts
      for (final post in userPosts) {
        if (post.postId != null) {
          final likes = await _likeRepo.getByPostId(post.postId!);
          for (final like in likes) {
            if (like.userId != userId) { // Don't show self-likes
              final notification = await _createLikeNotification(like, post);
              if (notification != null) {
                allNotifications.add(notification);
              }
            }
          }
        }
      }

      // 3. Fetch comments on user's posts
      for (final post in userPosts) {
        if (post.postId != null) {
          final comments = await _commentRepo.getByPostId(post.postId!);
          for (final comment in comments) {
            if (comment.userId != userId) { // Don't show self-comments
              final notification = await _createCommentNotification(comment, post);
              if (notification != null) {
                allNotifications.add(notification);
              }
            }
          }
        }
      }

      // 4. Fetch follows (people who followed the user)
      final allFollows = await _followRepo.getAll();
      final userFollowers = allFollows.where((f) => f.followingId == userId).toList();
      
      for (final follow in userFollowers) {
        if (follow.followerId != userId) { // Don't show self-follows
          final notification = await _createFollowNotification(follow);
          if (notification != null) {
            allNotifications.add(notification);
          }
        }
      }

      // 5. Sort all notifications by date (newest first)
      allNotifications.sort((a, b) {
        final dateA = DateTime.parse(a.createdAt);
        final dateB = DateTime.parse(b.createdAt);
        return dateB.compareTo(dateA); // Newest first
      });

      // 6. Emit loaded state
      emit(NotificationsLoaded(allNotifications));
    } catch (e) {
      print('Error loading notifications: $e');
      emit(NotificationsError('Failed to load notifications'));
    }
  }

  Future<NotificationItemData?> _createLikeNotification(LikeModel like, PostModel post) async {
    try {
      final user = await _userRepo.getById(like.userId ?? -1);
      if (user == null) return null;

      final profileImagePath = await _getValidProfileImagePath(user.userId!, user.pfp);

      return NotificationItemData(
        sourceUsername: user.username ?? 'User',
        sourceUserId: user.userId!,
        sourceProfileImage: profileImagePath,
        type: 'like',
        createdAt: like.date ?? DateTime.now().toIso8601String(),
        sourcePostId: post.postId?.toString(),
      );
    } catch (e) {
      print('Error creating like notification: $e');
      return null;
    }
  }

  Future<NotificationItemData?> _createCommentNotification(CommentModel comment, PostModel post) async {
    try {
      final user = await _userRepo.getById(comment.userId ?? -1);
      if (user == null) return null;

      final profileImagePath = await _getValidProfileImagePath(user.userId!, user.pfp);

      return NotificationItemData(
        sourceUsername: user.username ?? 'User',
        sourceUserId: user.userId!,
        sourceProfileImage: profileImagePath,
        type: 'comment',
        createdAt: comment.date ?? DateTime.now().toIso8601String(),
        sourcePostId: post.postId?.toString(),
        commentText: comment.content, // Add comment text
      );
    } catch (e) {
      print('Error creating comment notification: $e');
      return null;
    }
  }

  Future<NotificationItemData?> _createFollowNotification(FollowingFollower follow) async {
    try {
      final user = await _userRepo.getById(follow.followerId);
      if (user == null) return null;

      final profileImagePath = await _getValidProfileImagePath(user.userId!, user.pfp);

      return NotificationItemData(
        sourceUsername: user.username ?? 'User',
        sourceUserId: user.userId!,
        sourceProfileImage: profileImagePath,
        type: 'follow',
        createdAt: follow.date ?? DateTime.now().toIso8601String(),
        sourcePostId: null,
      );
    } catch (e) {
      print('Error creating follow notification: $e');
      return null;
    }
  }

  Future<String> _getValidProfileImagePath(int userId, String? pfpPath) async {
    if (pfpPath != null && pfpPath.isNotEmpty) {
      if (pfpPath.startsWith('assets/')) {
        return pfpPath;
      }
      
      final file = File(pfpPath);
      final fileExists = await file.exists();
      if (fileExists) {
        return pfpPath;
      }
    }
    
    final userProfilePath = await UserProfileService.getUserProfileImagePath(userId);
    if (userProfilePath != null) {
      return userProfilePath;
    }
    
    return 'assets/images/icons/person.jpg';
  }

  String getTimeAgo(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) return '${difference.inDays}d ago';
      if (difference.inHours > 0) return '${difference.inHours}h ago';
      if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
      return 'Just now';
    } catch (e) {
      return 'Recently';
    }
  }

  IconData getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.mode_comment;
      case 'follow':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Color getNotificationIconColor(String type) {
    switch (type) {
      case 'like':
        return Colors.red;
      case 'comment':
        return Colors.blue;
      case 'follow':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<String> getPostImage(String? postId) async {
    if (postId == null) return 'assets/images/placeholder_post.png';
    
    try {
      final postIdInt = int.tryParse(postId);
      if (postIdInt != null) {
        // Get post image from PostImageService if you have it, or from post model
        final posts = await _postRepo.getByPostId(postIdInt);
        if (posts.isNotEmpty && posts.first.imagePath != null) {
          return posts.first.imagePath!;
        }
      }
    } catch (e) {
      print('Error getting post image: $e');
    }
    
    return 'assets/images/placeholder_post.png';
  }

  String getNotificationText(String type, {String? commentText}) {
    switch (type) {
      case 'like':
        return ' liked your outfit';
      case 'comment':
        final trimmedText = commentText != null && commentText.length > 30 
            ? '${commentText.substring(0, 30)}...' 
            : commentText ?? '';
        return ' commented: "$trimmedText"';
      case 'follow':
        return ' started following you';
      default:
        return ' interacted with your content';
    }
  }

  // Method to refresh notifications
  Future<void> refreshNotifications(int userId) async {
    await loadNotifications(userId);
  }
}