import 'package:shared_preferences/shared_preferences.dart';
import 'package:vestium/repo/user_repo.dart';
import 'package:vestium/databases/db_models.dart';

class CurrentUserService {
  static User? _currentUser;
  static final UserRepo _userRepo = UserRepo();
  
  // SharedPreferences keys
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyLastUserId = 'last_user_id';

  static User? get currentUser => _currentUser;
  static int? get currentUserId => _currentUser?.userId;
  static bool get isLoggedIn => _currentUser != null;

  /// Set current user and persist login state
  static Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    
    // Save login state to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setInt(_keyLastUserId, user.userId ?? -1);
    
    print('✅ Current user set: ${user.email} (ID: ${user.userId})');
  }

  /// Clear current user and logout state
  static Future<void> clearCurrentUser() async {
    _currentUser = null;
    
    // Clear login state from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyLastUserId);
    
    print('✅ Current user cleared (logged out)');
  }

  /// Load user from database only if they were logged in
  /// Call this on app startup
  static Future<void> loadLastUserFromDatabase() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      
      // Only auto-login if user was previously logged in
      if (!isLoggedIn) {
        print('🔒 No active login session found');
        return;
      }
      
      final lastUserId = prefs.getInt(_keyLastUserId);
      
      if (lastUserId == null || lastUserId == -1) {
        print('📭 No last user ID found');
        return;
      }
      
      // Load the specific user by ID
      final user = await _userRepo.getById(lastUserId);
      
      if (user != null) {
        _currentUser = user;
        print('✅ Loaded last logged-in user: ${user.email}');
      } else {
        print('⚠️ Last user not found in database');
        await clearCurrentUser(); // Clean up invalid state
      }
    } catch (e) {
      print('❌ Error loading last user: $e');
      await clearCurrentUser(); // Clean up on error
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
      await clearCurrentUser(); // This will also clear SharedPreferences
      print('✅ Account deleted from database');
    } catch (e) {
      print('❌ Error deleting account: $e');
      rethrow;
    }
  }
  
  /// Check if user should be auto-logged in
  /// Useful for splash screen or initial navigation
  static Future<bool> shouldAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}