// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';
// import 'package:flutter/foundation.dart';

// class UserRepo {
//   Future<List<User>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('user');
//     return res.map((m) => User.fromMap(m)).toList();
//   }

//   Future<User?> getById(int id) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('user', where: 'user_id = ?', whereArgs: [id]);
//     if (res.isEmpty) return null;
//     return User.fromMap(res.first);
//   }

//   Future<User?> getByEmail(String email) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('user', where: 'email = ?', whereArgs: [email]);
//     if (res.isEmpty) return null;
//     return User.fromMap(res.first);
//   }

//   Future<bool> update(int id, User user) async {
//     final db = await DBHelper.getDatabase();
//     await db.update(
//       'user',
//       user.toMap(),
//       where: 'user_id = ?',
//       whereArgs: [id],
//     );
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete('user', where: 'user_id = ?', whereArgs: [id]);
//     return true;
//   }

//   // ------------------------
//   // INSERT METHOD (Added since it was missing from your list)
//   // ------------------------

//   Future<bool> insert(User user) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert(
//       'user',
//       user.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     debugPrint('Inserted user: ${user.email}');
//     return true;
//   }

//   // ------------------------
//   // AUTHENTICATION METHODS (Built using the above methods)
//   // ------------------------

//   /// Sign up a new user
//   /// Throws an exception if email already exists
//   Future<User> signUp({
//     required String email,
//     required String password,
//     required String fullName,
//     String? username,
//     String? bio,
//   }) async {
//     // Validate required fields
//     if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
//       throw Exception('Email, password, and full name are required');
//     }

//     // Check if email already exists using getByEmail method
//     final existingUser = await getByEmail(email);
//     if (existingUser != null) {
//       throw Exception(
//         'This email is already registered. Please use a different email or login.',
//       );
//     }

//     // Validate password strength (basic validation)
//     if (password.length < 6) {
//       throw Exception('Password must be at least 6 characters long');
//     }

//     // Validate email format (basic validation)
//     if (!email.contains('@') || !email.contains('.')) {
//       throw Exception('Please enter a valid email address');
//     }

//     // Generate username from fullName if not provided
//     final generatedUsername =
//         username ?? fullName.replaceAll(' ', '').toLowerCase();

//     // Create new user object with current timestamp
//     final user = User(
//       email: email,
//       password: password,
//       fullName: fullName,
//       username: generatedUsername,
//       bio: bio ?? '',
//       dateCreated: DateTime.now().toIso8601String(),
//       cameraPermission: 0,
//       galleryPermission: 0,
//     );

//     // Insert user into database using insert method
//     final success = await insert(user);

//     if (!success) {
//       throw Exception('Failed to create user account');
//     }

//     // Return the user by fetching it with getByEmail to get the generated ID
//     final createdUser = await getByEmail(email);
//     if (createdUser == null) {
//       throw Exception('Failed to retrieve created user');
//     }

//     return createdUser;
//   }

//   /// Sign in user with email and password
//   /// Throws an exception if credentials are invalid
//   Future<User> signIn(String email, String password) async {
//     if (email.isEmpty || password.isEmpty) {
//       throw Exception('Please enter both email and password');
//     }

//     // Get user by email using getByEmail method
//     final user = await getByEmail(email);

//     if (user != null && user.password == password) {
//       return user;
//     } else {
//       throw Exception('Invalid email or password. Please try again.');
//     }
//   }

//   // ------------------------
//   // VALIDATION METHODS (Built using the above methods)
//   // ------------------------

//   /// Check if email is available for registration
//   /// Returns true if email is available, false if already taken
//   Future<bool> isEmailAvailable(String email) async {
//     if (email.isEmpty || !email.contains('@')) {
//       return false;
//     }
//     final user = await getByEmail(email);
//     return user == null;
//   }

//   /// Check if user exists by email
//   Future<bool> userExists(String email) async {
//     final user = await getByEmail(email);
//     return user != null;
//   }

//   /// Check if user exists by ID
//   Future<bool> userExistsById(int userId) async {
//     final user = await getById(userId);
//     return user != null;
//   }

//   // ------------------------
//   // USER PROFILE METHODS (Built using the above methods)
//   // ------------------------

//   /// Get user by username
//   Future<User?> getByUsername(String username) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'user',
//       where: 'username = ?',
//       whereArgs: [username],
//     );
//     if (res.isEmpty) return null;
//     return User.fromMap(res.first);
//   }

//   /// Update user profile with validation
//   Future<User> updateUserProfile(User user) async {
//     if (user.userId == null) {
//       throw Exception('Cannot update user without ID');
//     }

//     final success = await update(user.userId!, user);

//     if (success) {
//       return user;
//     } else {
//       throw Exception('Failed to update user profile. User may not exist.');
//     }
//   }

//   /// Update specific user fields without replacing entire profile
//   Future<User> updateUserPartial({
//     required int userId,
//     String? username,
//     String? fullName,
//     String? bio,
//     String? pfp,
//     int? cameraPermission,
//     int? galleryPermission,
//   }) async {
//     // First get the current user using getById method
//     final currentUser = await getById(userId);
//     if (currentUser == null) {
//       throw Exception('User not found');
//     }

//     // Create updated user with only the changed fields
//     final updatedUser = currentUser.copyWith(
//       username: username,
//       fullName: fullName,
//       bio: bio,
//       pfp: pfp,
//       cameraPermission: cameraPermission,
//       galleryPermission: galleryPermission,
//     );

//     return await updateUserProfile(updatedUser);
//   }

//   // ------------------------
//   // PERMISSION METHODS (Built using the above methods)
//   // ------------------------

//   /// Update camera permission for user
//   Future<User> updateCameraPermission(int userId, bool granted) async {
//     return await updateUserPartial(
//       userId: userId,
//       cameraPermission: granted ? 1 : 0,
//     );
//   }

//   /// Update gallery permission for user
//   Future<User> updateGalleryPermission(int userId, bool granted) async {
//     return await updateUserPartial(
//       userId: userId,
//       galleryPermission: granted ? 1 : 0,
//     );
//   }

//   // ------------------------
//   // UTILITY METHODS (Built using the above methods)
//   // ------------------------

//   /// Delete user by email
//   Future<bool> deleteUserByEmail(String email) async {
//     final user = await getByEmail(email);
//     if (user?.userId != null) {
//       return await delete(user!.userId!);
//     }
//     return false;
//   }

//   /// Delete user by ID (alias for delete method)
//   Future<bool> deleteUserById(int userId) async {
//     return await delete(userId);
//   }
// }

// =============================================================

// lib/repo/user_repo.dart - CORRECT IMPLEMENTATION
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class UserRepo {
  static final UserRepo _instance = UserRepo._internal();
  factory UserRepo() => _instance;
  UserRepo._internal();

  final ApiService _api = ApiService();

  // KEEP ALL ORIGINAL METHODS

  Future<List<User>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('user');
    return res.map((m) => User.fromMap(m)).toList();
  }

  Future<User?> getById(int id) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('user', where: 'user_id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<User?> getByEmail(String email) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('user', where: 'email = ?', whereArgs: [email]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  // MODIFIED: update with optional server sync
  Future<bool> update(int id, User user) async {
    final db = await DBHelper.getDatabase();

    // 1. Update in local database
    await db.update(
      'user',
      user.toMap(),
      where: 'user_id = ?',
      whereArgs: [id],
    );

    // 2. NEW: Sync to server if it's a server user (ID ≥ 1000)
    // But only sync non-sensitive profile data
    if (_isServerId(id)) {
      await _syncProfileToServer(user);
    }

    return true;
  }

  // MODIFIED: delete with server notification
  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();

    // 1. Check if this is a server user
    final user = await getById(id);
    final isServerUser = user != null && _isServerId(id);

    // 2. Delete from local database
    await db.delete('user', where: 'user_id = ?', whereArgs: [id]);

    // 3. NEW: If it was a server user, notify about account deletion
    // (Actual deletion happens through auth endpoint)
    if (isServerUser) {
      print(
        '⚠️ Server user deleted locally. Use auth endpoint for account deletion.',
      );
    }

    return true;
  }

  // MODIFIED: insert handles both local and server users
  Future<bool> insert(User user) async {
    final db = await DBHelper.getDatabase();

    // Insert to local database
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    debugPrint('Inserted user: ${user.email}');
    return true;
  }

  // NEW: Register user with server (main auth flow)
  Future<User> registerWithServer({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String? bio,
  }) async {
    try {
      // 1. Call server registration endpoint
      final response = await _api.register(
        email: email,
        password: password,
        fullName: fullName,
        username: username,
        bio: bio,
      );

      // 2. Save server user to local database
      final serverUser = User.fromMap(response['user']);
      await insert(serverUser);

      debugPrint('✅ User registered with server: ${serverUser.email}');
      return serverUser;
    } catch (e) {
      debugPrint('❌ Server registration failed: $e');
      rethrow;
    }
  }

  // NEW: Login with server (main auth flow)
  Future<User> loginWithServer(String email, String password) async {
    try {
      // 1. Call server login endpoint
      final response = await _api.login(email, password);

      // 2. Save server user to local database
      final serverUser = User.fromMap(response['user']);
      await insert(serverUser);

      debugPrint('✅ User logged in with server: ${serverUser.email}');
      return serverUser;
    } catch (e) {
      debugPrint('❌ Server login failed: $e');
      rethrow;
    }
  }

  // NEW: Sync profile updates to server
  Future<void> _syncProfileToServer(User user) async {
    if (user.userId == null) return;

    try {
      // Prepare only the fields we want to sync
      final profileData = {
        if (user.username != null) 'username': user.username,
        if (user.fullName != null) 'full_name': user.fullName,
        if (user.bio != null) 'bio': user.bio,
        if (user.pfp != null) 'pfp': user.pfp,
      };

      // Only sync if there are fields to update
      if (profileData.isNotEmpty) {
        await _api.updateUserProfile(profileData);
        print('✅ Profile synced to server for user ${user.userId}');
      }
    } catch (e) {
      debugPrint('❌ Profile sync failed: $e');
      // You might want to queue this for retry later
      await _queueProfileUpdateForRetry(user);
    }
  }

  // In user_repo.dart
  Future<void> retryFailedProfileUpdates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final failedUpdates = prefs.getStringList('failed_profile_updates') ?? [];

      if (failedUpdates.isEmpty) return;

      print('🔄 Retrying ${failedUpdates.length} failed profile updates...');

      final successfulUpdates = <String>[];

      for (final updateJson in failedUpdates) {
        try {
          final updateData = json.decode(updateJson);
          final userId = updateData['user_id'];
          final user = await getById(userId);

          if (user != null) {
            final profileData = {
              'username': updateData['username'],
              'full_name': updateData['full_name'],
              'bio': updateData['bio'],
              'pfp': updateData['pfp'],
            };

            await _api.updateUserProfile(profileData);
            successfulUpdates.add(updateJson);
            print('✅ Retried profile update for user $userId');
          }
        } catch (e) {
          print('❌ Failed to retry profile update: $e');
          continue;
        }
      }

      // Remove successful updates from the list
      final remainingUpdates = failedUpdates
          .where((update) => !successfulUpdates.contains(update))
          .toList();

      await prefs.setStringList('failed_profile_updates', remainingUpdates);

      if (successfulUpdates.isNotEmpty) {
        print(
          '✅ Successfully retried ${successfulUpdates.length} profile updates',
        );
      }
    } catch (e) {
      print('❌ Error retrying profile updates: $e');
    }
  }

  // Optional: Add retry mechanism
  Future<void> _queueProfileUpdateForRetry(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final failedUpdates = prefs.getStringList('failed_profile_updates') ?? [];

    final updateData = {
      'user_id': user.userId,
      'username': user.username,
      'full_name': user.fullName,
      'bio': user.bio,
      'pfp': user.pfp,
      'timestamp': DateTime.now().toIso8601String(),
    };

    failedUpdates.add(json.encode(updateData));
    await prefs.setStringList('failed_profile_updates', failedUpdates);

    print('📝 Queued profile update for retry: user ${user.userId}');
  }

  // ------------------------
  // REST OF ORIGINAL METHODS (unchanged)
  // ------------------------

  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String? bio,
  }) async {
    // Validation
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      throw Exception('Email, password, and full name are required');
    }

    // Check if email already exists
    final existingUser = await getByEmail(email);
    if (existingUser != null) {
      throw Exception('This email is already registered.');
    }

    // Validate password
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }

    // Validate email
    if (!email.contains('@') || !email.contains('.')) {
      throw Exception('Please enter a valid email address');
    }

    // Generate username
    final generatedUsername =
        username ?? fullName.replaceAll(' ', '').toLowerCase();

    // Create local user
    final user = User(
      email: email,
      password: password,
      fullName: fullName,
      username: generatedUsername,
      bio: bio ?? '',
      dateCreated: DateTime.now().toIso8601String(),
      cameraPermission: 0,
      galleryPermission: 0,
    );

    // Save locally
    final success = await insert(user);
    if (!success) {
      throw Exception('Failed to create user account');
    }

    // Return created user
    final createdUser = await getByEmail(email);
    if (createdUser == null) {
      throw Exception('Failed to retrieve created user');
    }

    return createdUser;
  }

  Future<User> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Please enter both email and password');
    }

    final user = await getByEmail(email);

    if (user != null && user.password == password) {
      return user;
    } else {
      throw Exception('Invalid email or password. Please try again.');
    }
  }

  Future<bool> isEmailAvailable(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      return false;
    }
    final user = await getByEmail(email);
    return user == null;
  }

  Future<bool> userExists(String email) async {
    final user = await getByEmail(email);
    return user != null;
  }

  Future<bool> userExistsById(int userId) async {
    final user = await getById(userId);
    return user != null;
  }

  Future<User?> getByUsername(String username) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'user',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<User> updateUserProfile(User user) async {
    if (user.userId == null) {
      throw Exception('Cannot update user without ID');
    }

    final success = await update(user.userId!, user);

    if (success) {
      return user;
    } else {
      throw Exception('Failed to update user profile. User may not exist.');
    }
  }

  Future<User> updateUserPartial({
    required int userId,
    String? username,
    String? fullName,
    String? bio,
    String? pfp,
    int? cameraPermission,
    int? galleryPermission,
  }) async {
    final currentUser = await getById(userId);
    if (currentUser == null) {
      throw Exception('User not found');
    }

    final updatedUser = currentUser.copyWith(
      username: username,
      fullName: fullName,
      bio: bio,
      pfp: pfp,
      cameraPermission: cameraPermission,
      galleryPermission: galleryPermission,
    );

    return await updateUserProfile(updatedUser);
  }

  Future<User> updateCameraPermission(int userId, bool granted) async {
    return await updateUserPartial(
      userId: userId,
      cameraPermission: granted ? 1 : 0,
    );
  }

  Future<User> updateGalleryPermission(int userId, bool granted) async {
    return await updateUserPartial(
      userId: userId,
      galleryPermission: granted ? 1 : 0,
    );
  }

  Future<bool> deleteUserByEmail(String email) async {
    final user = await getByEmail(email);
    if (user?.userId != null) {
      return await delete(user!.userId!);
    }
    return false;
  }

  Future<bool> deleteUserById(int userId) async {
    return await delete(userId);
  }

  // Helper methods

  bool _isServerId(int id) {
    return id >= 1000;
  }

  // NEW: Get current server user
  Future<User?> getCurrentServerUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId != null && _isServerId(userId)) {
      return await getById(userId);
    }
    return null;
  }

  // NEW: Check if current user is logged in with server
  Future<bool> isServerUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final token = prefs.getString('access_token');

    return userId != null && _isServerId(userId) && token != null;
  }

  // NEW: Logout from server
  Future<void> logoutFromServer() async {
    try {
      // Call server logout endpoint
      await _api.authenticatedRequest(
        Uri.parse('${ApiService.baseUrl}/auth/logout'),
        method: 'POST',
      );
    } catch (e) {
      debugPrint('⚠️ Server logout failed: $e');
    }

    // Clear local tokens
    _api.logout();
  }

  // NEW: Change password on server
  Future<void> changePasswordOnServer({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _api.authenticatedRequest(
        Uri.parse('${ApiService.baseUrl}/auth/change-password'),
        method: 'PUT',
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    } catch (e) {
      debugPrint('❌ Password change failed: $e');
      rethrow;
    }
  }
}
