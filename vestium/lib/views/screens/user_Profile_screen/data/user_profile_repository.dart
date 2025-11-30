import '../../../../data/dummy/dummy-data-loader.dart';

class UserProfileRepository {
  Future<Map<String, dynamic>> loadProfile(int userId) async {
    final data = await DummyDataLoader.loadDummyData();
    final users = data['users'] as List<dynamic>;
    final posts = data['posts'] as List<dynamic>;

    final user = users.firstWhere(
      (u) => u['id'].toString() == userId.toString(),
      orElse: () => null,
    );

    if (user == null) throw Exception("User not found");

    final userPosts = posts
        .where((p) => p['userId'].toString() == userId.toString())
        .toList();

    return {
      "user": user,
      "posts": userPosts,
    };
  }
}
