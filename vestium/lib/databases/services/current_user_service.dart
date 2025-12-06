import 'package:vestium/repo/user_repo.dart';
import 'package:vestium/databases/db_models.dart';

class CurrentUserService {
  static User? _currentUser;
  static final UserRepo _userRepo = UserRepo();

  static User? get currentUser => _currentUser;
  static int? get currentUserId => _currentUser?.userId;
  static bool get isLoggedIn => _currentUser != null;

  static void setCurrentUser(User user) {
    _currentUser = user;
    print('✅ Current user set: ${user.email} (ID: ${user.userId})');
  }

  static void clearCurrentUser() {
    _currentUser = null;
    print('✅ Current user cleared');
  }

  static Future<void> loadLastUserFromDatabase() async {
    try {
      final users = await _userRepo.getAll();

      if (users.isNotEmpty) {
        users.sort((a, b) {
          final dateA = DateTime.parse(a.dateCreated ?? '2000-01-01');
          final dateB = DateTime.parse(b.dateCreated ?? '2000-01-01');
          return dateB.compareTo(dateA);
        });

        final latestUser = users.first;
        setCurrentUser(latestUser);
        print('✅ Loaded last user from database: ${latestUser.email}');
      } else {
        print('📭 No users found in database');
      }
    } catch (e) {
      print('❌ Error loading last user: $e');
    }
  }

  /// Update ONLY the in-memory cache (database already updated in cubit)
  static Future<User> updateCurrentUser(User updatedUser) async {
    if (_currentUser?.userId == null) {
      throw Exception('No current user to update');
    }

    // IMPORTANT: Do NOT call _userRepo.update() here
    // Database is already updated in the cubit
    // This method ONLY updates the in-memory cache
    _currentUser = updatedUser;
    print('✅ CurrentUserService cache updated');
    return updatedUser;
  }

  /// Clear current user and database on account deletion
  static Future<void> deleteAccountFromDatabase(int userId) async {
    try {
      await _userRepo.delete(userId);
      _currentUser = null;
      print('✅ Account deleted from database');
    } catch (e) {
      print('❌ Error deleting account: $e');
      rethrow;
    }
  }
}
