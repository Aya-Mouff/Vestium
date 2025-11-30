import '../../../../data/dummy/dummy-data-loader.dart';

class MyProfileDataSource {
  Future<Map<String, dynamic>> loadUserProfile(int userId) async {
    final data = await DummyDataLoader.loadDummyData();

    final users = data['users'] as List<dynamic>;
    final outfits = data['outfits'] as List<dynamic>;
    final posts = data['posts'] as List<dynamic>;

    final user = users.firstWhere(
      (u) => u['id'].toString() == userId.toString(),
      orElse: () => {},
    );

    final userOutfits = outfits
        .where((o) => o['userId'].toString() == userId.toString())
        .toList();

    final userPosts = posts
        .where((p) => p['userId'].toString() == userId.toString())
        .toList();

    return {
      "user": user,
      "outfits": userOutfits,
      "posts": userPosts,
    };
  }
}
