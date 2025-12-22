// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Local dev: 10.0.2.2 for Android emulator, localhost for iOS
  static const String _baseUrl = 'http://10.0.2.2:5000/api'; // Android emulator
  // static const String _baseUrl = 'http://localhost:5000/api'; // iOS simulator
  // static const String _baseUrl = 'http://YOUR_LOCAL_IP:5000/api'; // Physical device
  
  String? _accessToken;
  String? _refreshToken;
  int? _userId;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
    _userId = prefs.getInt('user_id');
  }

  // ========== AUTHENTICATION ==========
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Save tokens
      _accessToken = data['access_token'];
      _refreshToken = data['refresh_token'];
      _userId = data['user']['user_id'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _accessToken!);
      await prefs.setString('refresh_token', _refreshToken!);
      await prefs.setInt('user_id', _userId!);
      
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String? bio,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'full_name': fullName,
        'username': username,
        'bio': bio,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      
      // Save tokens
      _accessToken = data['access_token'];
      _refreshToken = data['refresh_token'];
      _userId = data['user']['user_id'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _accessToken!);
      await prefs.setString('refresh_token', _refreshToken!);
      await prefs.setInt('user_id', _userId!);
      
      return data;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  // ========== ITEMS (SYNC WITH LOCAL) ==========
  Future<List<dynamic>> getItemsFromBackend() async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/items'),
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  Future<Map<String, dynamic>> createItemOnBackend({
    required String name,
    required String imagePath,
    String? description,
    String? season,
    List<String>? categories,
  }) async {
    // Create multipart request for file upload
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/items'),
    );
    
    // Add authorization header
    request.headers['Authorization'] = 'Bearer $_accessToken';
    
    // Add image file
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imagePath,
      ),
    );
    
    // Add fields
    request.fields['name'] = name;
    if (description != null) request.fields['description'] = description;
    if (season != null) request.fields['season'] = season;
    if (categories != null) {
      request.fields['categories'] = json.encode(categories);
    }
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create item: ${response.body}');
    }
  }

  // ========== OUTFITS ==========
  Future<List<dynamic>> getOutfitsFromBackend() async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/outfits'),
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['outfits'];
    } else {
      throw Exception('Failed to fetch outfits');
    }
  }

  // ========== POSTS & FEED ==========
  Future<List<dynamic>> getFeedPosts({int limit = 10, int offset = 0}) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/feed?limit=$limit&offset=$offset'),
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['posts'];
    } else {
      throw Exception('Failed to fetch feed');
    }
  }

  // ========== HELPER METHODS ==========
  Future<http.Response> _authenticatedRequest(
    Uri url, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };

    switch (method) {
      case 'GET':
        return await http.get(url, headers: headers);
      case 'POST':
        return await http.post(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
      case 'PUT':
        return await http.put(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
      case 'DELETE':
        return await http.delete(url, headers: headers);
      default:
        throw Exception('Unsupported HTTP method');
    }
  }

  bool get isLoggedIn => _accessToken != null;
  int? get userId => _userId;

  static String get baseUrl => _baseUrl;
  
  // Make _authenticatedRequest public or create a public wrapper
  Future<http.Response> authenticatedRequest(
    Uri url, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    return await _authenticatedRequest(url, method: method, body: body);
  }

  // Sync endpoints
  Future<Map<String, dynamic>> syncPull() async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/sync/pull'),
      method: 'POST',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to pull sync data: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> syncPush(Map<String, dynamic> data) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/sync/push'),
      method: 'POST',
      body: data,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to push sync data: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> syncStatus() async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/sync/status'),
      method: 'GET',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get sync status: ${response.body}');
    }
  }

  // Item sync methods
  Future<Map<String, dynamic>> createItemBackend(Map<String, dynamic> data) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/items'),
      method: 'POST',
      body: data,
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create item: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateItemBackend(int itemId, Map<String, dynamic> data) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/items/$itemId'),
      method: 'PUT',
      body: data,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update item: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> deleteItemBackend(int itemId) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/items/$itemId'),
      method: 'DELETE',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete item: ${response.body}');
    }
  }

  // Outfit sync methods
  Future<Map<String, dynamic>> createOutfitBackend(Map<String, dynamic> data) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/outfits'),
      method: 'POST',
      body: data,
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create outfit: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateOutfitBackend(int outfitId, Map<String, dynamic> data) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/outfits/$outfitId'),
      method: 'PUT',
      body: data,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update outfit: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> deleteOutfitBackend(int outfitId) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/outfits/$outfitId'),
      method: 'DELETE',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete outfit: ${response.body}');
    }
  }

  // Post sync methods
  Future<Map<String, dynamic>> createPostBackend(Map<String, dynamic> data) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/posts'),
      method: 'POST',
      body: data,
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create post: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updatePostBackend(int postId, Map<String, dynamic> data) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/posts/$postId'),
      method: 'PUT',
      body: data,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update post: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> deletePostBackend(int postId) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/posts/$postId'),
      method: 'DELETE',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete post: ${response.body}');
    }
  }

  // Comment sync methods
  Future<Map<String, dynamic>> createCommentBackend(int postId, String content) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/posts/$postId/comments'),
      method: 'POST',
      body: {'content': content},
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create comment: ${response.body}');
    }
  }

  // Like sync methods
  Future<Map<String, dynamic>> likePostBackend(int postId) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/posts/$postId/like'),
      method: 'POST',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to like post: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> unlikePostBackend(int postId) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/posts/$postId/like'),
      method: 'DELETE',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to unlike post: ${response.body}');
    }
  }

  // Follow sync methods
  Future<Map<String, dynamic>> followUserBackend(int userId) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/users/$userId/follow'),
      method: 'POST',
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to follow user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> unfollowUserBackend(int userId) async {
    final response = await _authenticatedRequest(
      Uri.parse('$_baseUrl/users/$userId/unfollow'),
      method: 'POST',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to unfollow user: ${response.body}');
    }
  }
}