import 'package:equatable/equatable.dart';

class NotificationItemData extends Equatable {
  final String sourceUsername;
  final int sourceUserId;
  final String sourceProfileImage;
  final String type;
  final String createdAt;
  final String? sourcePostId;
  final String? commentText; // Add this for comment notifications

  const NotificationItemData({
    required this.sourceUsername,
    required this.sourceUserId,
    required this.sourceProfileImage,
    required this.type,
    required this.createdAt,
    this.sourcePostId,
    this.commentText,
  });

  @override
  List<Object?> get props => [sourceUsername, sourceUserId, sourceProfileImage, type, createdAt, sourcePostId, commentText];
}

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationItemData> notifications;
  const NotificationsLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}