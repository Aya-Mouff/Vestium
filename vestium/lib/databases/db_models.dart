// lib/databases/db_models.dart

// ------------------------
// USER
// ------------------------
class User {
  int? userId;
  String? username;
  String? fullName;
  String? bio;
  String? pfp;
  String? email;
  String? password;
  String? dateCreated;
  int? cameraPermission;
  int? galleryPermission;

  User({
    this.userId,
    this.username,
    this.fullName,
    this.bio,
    this.pfp,
    this.email,
    this.password,
    this.dateCreated,
    this.cameraPermission,
    this.galleryPermission,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
        userId: map['user_id'],
        username: map['username'],
        fullName: map['full_name'],
        bio: map['bio'],
        pfp: map['pfp'],
        email: map['email'],
        password: map['password'],
        dateCreated: map['date_created'],
        cameraPermission: map['camera_permission'],
        galleryPermission: map['gallery_permission'],
      );

  Map<String, dynamic> toMap() => {
        'user_id': userId,
        'username': username,
        'full_name': fullName,
        'bio': bio,
        'pfp': pfp,
        'email': email,
        'password': password,
        'date_created': dateCreated,
        'camera_permission': cameraPermission,
        'gallery_permission': galleryPermission,
      };
}

// ------------------------
// FOLLOWINGS / FOLLOWERS
// (composite primary key)
// ------------------------
class FollowingFollower {
  int followingId;
  int followerId;
  String? date;

  FollowingFollower({
    required this.followingId,
    required this.followerId,
    this.date,
  });

  factory FollowingFollower.fromMap(Map<String, dynamic> map) =>
      FollowingFollower(
        followingId: map['following_id'],
        followerId: map['follower_id'],
        date: map['date'],
      );

  Map<String, dynamic> toMap() => {
        'following_id': followingId,
        'follower_id': followerId,
        'date': date,
      };
}

// ------------------------
// ITEM CATEGORY
// ------------------------
class ItemCategory {
  int? categoryId;
  String? categoryName;

  ItemCategory({
    this.categoryId,
    this.categoryName,
  });

  factory ItemCategory.fromMap(Map<String, dynamic> map) => ItemCategory(
        categoryId: map['category_id'],
        categoryName: map['category_name'],
      );

  Map<String, dynamic> toMap() => {
        'category_id': categoryId,
        'category_name': categoryName,
      };
}

// ------------------------
// ITEM
// ------------------------
class ItemModel {
  int? itemId;
  int? userId; // FK → user.user_id
  String? imagePath;
  int? categoryId; // FK → items_categories.category_id (nullable!)
  String? itemName;
  String? description;
  String? season;
  String? date;

  ItemModel({
    this.itemId,
    this.userId,
    this.imagePath,
    this.categoryId,
    this.itemName,
    this.description,
    this.season,
    this.date,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) => ItemModel(
        itemId: map['item_id'],
        userId: map['user_id'],
        imagePath: map['image_path'],
        categoryId: map['category_id'],
        itemName: map['item_name'],
        description: map['description'],
        season: map['season'],
        date: map['date'],
      );

  Map<String, dynamic> toMap() => {
        'item_id': itemId,
        'user_id': userId,
        'image_path': imagePath,
        'category_id': categoryId,
        'item_name': itemName,
        'description': description,
        'season': season,
        'date': date,
      };
}

// ------------------------
// OUTFIT CATEGORY
// ------------------------
class OutfitCategory {
  int? categoryId;
  String? categoryName;

  OutfitCategory({this.categoryId, this.categoryName});

  factory OutfitCategory.fromMap(Map<String, dynamic> map) => OutfitCategory(
        categoryId: map['category_id'],
        categoryName: map['category_name'],
      );

  Map<String, dynamic> toMap() => {
        'category_id': categoryId,
        'category_name': categoryName,
      };
}

// ------------------------
// OUTFIT
// ------------------------
class OutfitModel {
  int? outfitId;
  int? userId; // FK → user
  String? outfitName;
  String? description;
  int? categoryId; // FK → outfit_categories.category_id (nullable!)
  String? date;
  String? season;

  OutfitModel({
    this.outfitId,
    this.userId,
    this.outfitName,
    this.description,
    this.categoryId,
    this.date,
    this.season,
  });

  factory OutfitModel.fromMap(Map<String, dynamic> map) => OutfitModel(
        outfitId: map['outfit_id'],
        userId: map['user_id'],
        outfitName: map['outfit_name'],
        description: map['description'],
        categoryId: map['category_id'],
        date: map['date'],
        season: map['season'],
      );

  Map<String, dynamic> toMap() => {
        'outfit_id': outfitId,
        'user_id': userId,
        'outfit_name': outfitName,
        'description': description,
        'category_id': categoryId,
        'date': date,
        'season': season,
      };
}

// ------------------------
// OUTFIT <-> ITEM (COMPOSITE PK)
// ------------------------
class OutfitItem {
  int outfitId;
  int itemId;

  OutfitItem({
    required this.outfitId,
    required this.itemId,
  });

  factory OutfitItem.fromMap(Map<String, dynamic> map) => OutfitItem(
        outfitId: map['outfit_id'],
        itemId: map['item_id'],
      );

  Map<String, dynamic> toMap() => {
        'outfit_id': outfitId,
        'item_id': itemId,
      };
}

// ------------------------
// POST (With caption added)
// ------------------------
class PostModel {
  int? postId;
  int? outfitId; // FK → outfits.outfit_id (nullable!)
  String? imagePath;
  String? caption; // ADDED
  String? date;

  PostModel({
    this.postId,
    this.outfitId,
    this.imagePath,
    this.caption,
    this.date,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) => PostModel(
        postId: map['post_id'],
        outfitId: map['outfit_id'],
        imagePath: map['image_path'],
        caption: map['caption'],
        date: map['date'],
      );

  Map<String, dynamic> toMap() => {
        'post_id': postId,
        'outfit_id': outfitId,
        'image_path': imagePath,
        'caption': caption,
        'date': date,
      };
}

// ------------------------
// COMMENT
// ------------------------
class CommentModel {
  int? commentId;
  int? postId; // FK → posts.post_id
  int? userId; // FK → user.user_id
  String? content;
  String? date;

  CommentModel({
    this.commentId,
    this.postId,
    this.userId,
    this.content,
    this.date,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
        commentId: map['comment_id'],
        postId: map['post_id'],
        userId: map['user_id'],
        content: map['content'],
        date: map['date'],
      );

  Map<String, dynamic> toMap() => {
        'comment_id': commentId,
        'post_id': postId,
        'user_id': userId,
        'content': content,
        'date': date,
      };
}

// ------------------------
// LIKE
// ------------------------
class LikeModel {
  int? likeId;
  int? postId; // FK → posts.post_id
  int? userId; // FK → user.user_id
  String? date;

  LikeModel({
    this.likeId,
    this.postId,
    this.userId,
    this.date,
  });

  factory LikeModel.fromMap(Map<String, dynamic> map) => LikeModel(
        likeId: map['like_id'],
        postId: map['post_id'],
        userId: map['user_id'],
        date: map['date'],
      );

  Map<String, dynamic> toMap() => {
        'like_id': likeId,
        'post_id': postId,
        'user_id': userId,
        'date': date,
      };
}
