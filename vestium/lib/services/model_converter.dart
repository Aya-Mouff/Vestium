import 'package:vestium/databases/db_models.dart';

class ModelConverter {
  static User userFromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      fullName: json['full_name'],
      bio: json['bio'],
      pfp: json['pfp'],
      email: json['email'],
      dateCreated: json['date_created'],
    );
  }
  
  static ItemModel itemFromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemId: json['item_id'],
      userId: json['user_id'],
      imagePath: json['image_path'],
      itemName: json['item_name'],
      description: json['description'],
      season: json['season'],
      date: json['date'],
    );
  }
  
  static OutfitModel outfitFromJson(Map<String, dynamic> json) {
    return OutfitModel(
      outfitId: json['outfit_id'],
      userId: json['user_id'],
      outfitName: json['outfit_name'],
      description: json['description'],
      date: json['date'],
      season: json['season'],
    );
  }
  
  static PostModel postFromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['post_id'],
      userId: json['user_id'],
      outfitId: json['outfit_id'],
      imagePath: json['image_path'],
      caption: json['caption'],
      date: json['date'],
    );
  }
}