import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import 'package:flutter/foundation.dart';

class UserRepo {

  
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

  Future<bool> update(int id, User user) async {
    final db = await DBHelper.getDatabase();
    await db.update('user', user.toMap(), where: 'user_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('user', where: 'user_id = ?', whereArgs: [id]);
    return true;
  }

  // ------------------------
  // INSERT METHOD (Added since it was missing from your list)
  // ------------------------

  Future<bool> insert(User user) async {
    final db = await DBHelper.getDatabase();
    await db.insert('user', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    debugPrint('Inserted user: ${user.email}');
    return true;
  }

  // ------------------------
  // AUTHENTICATION METHODS (Built using the above methods)
  // ------------------------

  /// Sign up a new user
  /// Throws an exception if email already exists
  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String? bio,
  }) async {
    // Validate required fields
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      throw Exception('Email, password, and full name are required');
    }

    // Check if email already exists using getByEmail method
    final existingUser = await getByEmail(email);
    if (existingUser != null) {
      throw Exception('This email is already registered. Please use a different email or login.');
    }

    // Validate password strength (basic validation)
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }

    // Validate email format (basic validation)
    if (!email.contains('@') || !email.contains('.')) {
      throw Exception('Please enter a valid email address');
    }

    // Create new user object with current timestamp
    final user = User(
      email: email,
      password: password,
      fullName: fullName,
      username: username,
      bio: bio,
      dateCreated: DateTime.now().toIso8601String(),
      cameraPermission: 0,
      galleryPermission: 0,
    );

    // Insert user into database using insert method
    final success = await insert(user);
    
    if (!success) {
      throw Exception('Failed to create user account');
    }

    // Return the user by fetching it with getByEmail to get the generated ID
    final createdUser = await getByEmail(email);
    if (createdUser == null) {
      throw Exception('Failed to retrieve created user');
    }

    return createdUser;
  }

  /// Sign in user with email and password
  /// Throws an exception if credentials are invalid
  Future<User> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Please enter both email and password');
    }

    // Get user by email using getByEmail method
    final user = await getByEmail(email);
    
    if (user != null && user.password == password) {
      return user;
    } else {
      throw Exception('Invalid email or password. Please try again.');
    }
  }

  // ------------------------
  // VALIDATION METHODS (Built using the above methods)
  // ------------------------

  /// Check if email is available for registration
  /// Returns true if email is available, false if already taken
  Future<bool> isEmailAvailable(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      return false;
    }
    final user = await getByEmail(email);
    return user == null;
  }

  /// Check if user exists by email
  Future<bool> userExists(String email) async {
    final user = await getByEmail(email);
    return user != null;
  }

  /// Check if user exists by ID
  Future<bool> userExistsById(int userId) async {
    final user = await getById(userId);
    return user != null;
  }

  // ------------------------
  // USER PROFILE METHODS (Built using the above methods)
  // ------------------------

  /// Get user by username
  Future<User?> getByUsername(String username) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('user', where: 'username = ?', whereArgs: [username]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  /// Update user profile with validation
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

  /// Update specific user fields without replacing entire profile
  Future<User> updateUserPartial({
    required int userId,
    String? username,
    String? fullName,
    String? bio,
    String? pfp,
    int? cameraPermission,
    int? galleryPermission,
  }) async {
    // First get the current user using getById method
    final currentUser = await getById(userId);
    if (currentUser == null) {
      throw Exception('User not found');
    }

    // Create updated user with only the changed fields
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

  // ------------------------
  // PERMISSION METHODS (Built using the above methods)
  // ------------------------

  /// Update camera permission for user
  Future<User> updateCameraPermission(int userId, bool granted) async {
    return await updateUserPartial(
      userId: userId,
      cameraPermission: granted ? 1 : 0,
    );
  }

  /// Update gallery permission for user
  Future<User> updateGalleryPermission(int userId, bool granted) async {
    return await updateUserPartial(
      userId: userId,
      galleryPermission: granted ? 1 : 0,
    );
  }

  // ------------------------
  // UTILITY METHODS (Built using the above methods)
  // ------------------------

  /// Delete user by email
  Future<bool> deleteUserByEmail(String email) async {
    final user = await getByEmail(email);
    if (user?.userId != null) {
      return await delete(user!.userId!);
    }
    return false;
  }

  /// Delete user by ID (alias for delete method)
  Future<bool> deleteUserById(int userId) async {
    return await delete(userId);
  }
}