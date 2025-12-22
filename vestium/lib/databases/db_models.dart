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

  // ADD THIS copyWith METHOD:
  User copyWith({
    int? userId,
    String? username,
    String? fullName,
    String? bio,
    String? pfp,
    String? email,
    String? password,
    String? dateCreated,
    int? cameraPermission,
    int? galleryPermission,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      pfp: pfp ?? this.pfp,
      email: email ?? this.email,
      password: password ?? this.password,
      dateCreated: dateCreated ?? this.dateCreated,
      cameraPermission: cameraPermission ?? this.cameraPermission,
      galleryPermission: galleryPermission ?? this.galleryPermission,
    );
  }
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
  String? itemName;
  String? description;
  String? season;
  String? date;

  ItemModel({
    this.itemId,
    this.userId,
    this.imagePath,
    this.itemName,
    this.description,
    this.season,
    this.date,
  });
 
  factory ItemModel.fromMap(Map<String, dynamic> map) => ItemModel(
        itemId: map['item_id'],
        userId: map['user_id'],
        imagePath: map['image_path'],
        itemName: map['item_name'],
        description: map['description'],
        season: map['season'],
        date: map['date'],
      );

  Map<String, dynamic> toMap() => {
        'item_id': itemId,
        'user_id': userId,
        'image_path': imagePath,
        'item_name': itemName,
        'description': description,
        'season': season,
        'date': date,
      };

  // ADD THIS copyWith METHOD:
  ItemModel copyWith({
    int? itemId,
    int? userId,
    String? imagePath,
    String? itemName,
    String? description,
    String? season,
    String? date,
  }) {
    return ItemModel(
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      imagePath: imagePath ?? this.imagePath,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      season: season ?? this.season,
      date: date ?? this.date,
    );
  }

  static ItemModel empty() {
    return ItemModel(
      itemId: -1,
      userId: -1,
      itemName: 'Empty Item',
      imagePath: null,
      
    );
  }
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
  int? userId;
  String? outfitName;
  String? description;
  String? date;
  String? season;

  OutfitModel({
    this.outfitId,
    this.userId,
    this.outfitName,
    this.description,
    this.date,
    this.season,
  });

  factory OutfitModel.fromMap(Map<String, dynamic> map) => OutfitModel(
        outfitId: map['outfit_id'],
        userId: map['user_id'],
        outfitName: map['outfit_name'],
        description: map['description'],
        date: map['date'],
        season: map['season'],
      );

  Map<String, dynamic> toMap() => {
        'outfit_id': outfitId,
        'user_id': userId,
        'outfit_name': outfitName,
        'description': description,
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
// OUTFIT <-> CATEGORY JOIN
// ------------------------
class OutfitCategoryJoin {
  int outfitId;
  int categoryId;

  OutfitCategoryJoin({
    required this.outfitId,
    required this.categoryId,
  });

  factory OutfitCategoryJoin.fromMap(Map<String, dynamic> map) => OutfitCategoryJoin(
        outfitId: map['outfit_id'],
        categoryId: map['category_id'],
      );

  Map<String, dynamic> toMap() => {
        'outfit_id': outfitId,
        'category_id': categoryId,
      };
}

// ------------------------
// POST (With caption added)
// ------------------------
// In db_models.dart, update the PostModel class:
// class PostModel {
//   int? postId;
//   int? outfitId;
//   String? imagePath;
//   String? caption;
//   String? date;

//   PostModel({
//     this.postId,
//     this.outfitId,
//     this.imagePath,
//     this.caption,
//     this.date,
//   });

//   factory PostModel.fromMap(Map<String, dynamic> map) => PostModel(
//         postId: map['post_id'],
//         outfitId: map['outfit_id'],
//         imagePath: map['image_path'],
//         caption: map['caption'],
//         date: map['date'],
//       );

//   Map<String, dynamic> toMap() => {
//         'post_id': postId,
//         'outfit_id': outfitId,
//         'image_path': imagePath,
//         'caption': caption,
//         'date': date,
//       };

//   // Add this copyWith method:
//   PostModel copyWith({
//     int? postId,
//     int? outfitId,
//     String? imagePath,
//     String? caption,
//     String? date,
//   }) {
//     return PostModel(
//       postId: postId ?? this.postId,
//       outfitId: outfitId ?? this.outfitId,
//       imagePath: imagePath ?? this.imagePath,
//       caption: caption ?? this.caption,
//       date: date ?? this.date,
//     );
//   }
// }

// Add this to your db_models.dart - Updated PostModel

class PostModel {
  int? postId;
  int? outfitId;
  int? userId;      // ← ADD THIS for gallery posts
  String? imagePath;
  String? caption;
  String? date;

  PostModel({
    this.postId,
    this.outfitId,
    this.userId,    // ← ADD THIS
    this.imagePath,
    this.caption,
    this.date,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) => PostModel(
        postId: map['post_id'],
        outfitId: map['outfit_id'],
        userId: map['user_id'],    // ← ADD THIS
        imagePath: map['image_path'],
        caption: map['caption'],
        date: map['date'],
      );

  Map<String, dynamic> toMap() => {
        'post_id': postId,
        'outfit_id': outfitId,
        'user_id': userId,         // ← ADD THIS
        'image_path': imagePath,
        'caption': caption,
        'date': date,
      };

  PostModel copyWith({
    int? postId,
    int? outfitId,
    int? userId,               // ← ADD THIS
    String? imagePath,
    String? caption,
    String? date,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      outfitId: outfitId ?? this.outfitId,
      userId: userId ?? this.userId,           // ← ADD THIS
      imagePath: imagePath ?? this.imagePath,
      caption: caption ?? this.caption,
      date: date ?? this.date,
    );
  }
}

// Create a new class to hold Post with counts
class PostWithCounts {
  final PostModel post;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByCurrentUser;

  PostWithCounts({
    required this.post,
    required this.likesCount,
    required this.commentsCount,
    required this.isLikedByCurrentUser,
  });
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

// ------------------------
// ITEM CATEGORY JOIN (many-to-many)
// ------------------------
class ItemCategoryJoin {
  int itemId;
  int categoryId;

  ItemCategoryJoin({
    required this.itemId,
    required this.categoryId,
  });

  factory ItemCategoryJoin.fromMap(Map<String, dynamic> map) => ItemCategoryJoin(
        itemId: map['item_id'],
        categoryId: map['category_id'],
      );

  Map<String, dynamic> toMap() => {
        'item_id': itemId,
        'category_id': categoryId,
      };
}
