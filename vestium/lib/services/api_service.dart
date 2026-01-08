// lib/services/api_service.dart - COMPLETE FIXED VERSION
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
    try {
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
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String? bio,
  }) async {
    try {
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
    } catch (e) {
      print('❌ Registration error: $e');
      rethrow;
    }
  }

  // Add to lib/services/api_service.dart
  Future<Map<String, dynamic>> updateUserProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/auth/update-profile'),
        method: 'PUT',
        body: profileData,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        // Update local user data if needed
        final updatedUser = result['user'];
        if (updatedUser != null) {
          print('✅ Profile updated on server');
        }
        return result;
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('❌ Profile update error: $e');
      rethrow;
    }
  }

  // ========== SYNC ENDPOINTS (CRITICAL FOR OFFLINE SYNC) ==========

  Future<Map<String, dynamic>> syncQueueOperation(
    Map<String, dynamic> data,
  ) async {
    try {
      print(
        '📤 Syncing queue operation: ${data['action']} for ${data['entity_type']}',
      );

      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/sync/queue'),
        method: 'POST',
        body: data,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('✅ Queue operation successful: $result');
        return result;
      } else {
        print(
          '❌ Queue operation failed: ${response.statusCode} - ${response.body}',
        );
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.body}',
          'status_code': response.statusCode,
        };
      }
    } catch (e) {
      print('❌ Queue operation error: $e');
      return {'success': false, 'error': e.toString(), 'exception': true};
    }
  }

  Future<Map<String, dynamic>> syncProcess() async {
    try {
      print('🔄 Processing sync queue...');

      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/sync/process'),
        method: 'POST',
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('✅ Sync process successful: $result');
        return result;
      } else {
        print(
          '❌ Sync process failed: ${response.statusCode} - ${response.body}',
        );
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      print('❌ Sync process error: $e');
      return {'success': false, 'error': e.toString(), 'exception': true};
    }
  }

  Future<Map<String, dynamic>> syncPull() async {
    try {
      print('📥 Pulling sync data...');

      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/sync/pull'),
        method: 'POST',
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print(
          '✅ Sync pull successful, got ${result['data']?.length ?? 0} entities',
        );
        return result;
      } else {
        print('❌ Sync pull failed: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.body}',
          'data': {'items': [], 'outfits': [], 'posts': []},
        };
      }
    } catch (e) {
      print('❌ Sync pull error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'data': {'items': [], 'outfits': [], 'posts': []},
        'exception': true,
      };
    }
  }

  Future<Map<String, dynamic>> syncStatus() async {
    try {
      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/sync/status'),
        method: 'GET',
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(
          '❌ Sync status failed: ${response.statusCode} - ${response.body}',
        );
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      print('❌ Sync status error: $e');
      return {'success': false, 'error': e.toString(), 'exception': true};
    }
  }

  // ========== ITEMS ==========
  Future<List<dynamic>> getItemsFromBackend() async {
    try {
      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/items'),
        method: 'GET',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['items'] ?? [];
      } else {
        throw Exception('Failed to fetch items: ${response.body}');
      }
    } catch (e) {
      print('❌ Get items error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createItemOnBackend({
    required String name,
    required String imagePath,
    String? description,
    String? season,
    List<String>? categories,
  }) async {
    try {
      // Create multipart request for file upload
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/items'));

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $_accessToken';

      // Add image file
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

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
    } catch (e) {
      print('❌ Create item error: $e');
      rethrow;
    }
  }

  // ========== OUTFITS ==========
  Future<List<dynamic>> getOutfitsFromBackend() async {
    try {
      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/outfits'),
        method: 'GET',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['outfits'] ?? [];
      } else {
        throw Exception('Failed to fetch outfits: ${response.body}');
      }
    } catch (e) {
      print('❌ Get outfits error: $e');
      return [];
    }
  }

  // ========== POSTS & FEED ==========
  Future<List<dynamic>> getFeedPosts({int limit = 10, int offset = 0}) async {
    try {
      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/feed?limit=$limit&offset=$offset'),
        method: 'GET',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['posts'] ?? [];
      } else {
        throw Exception('Failed to fetch feed: ${response.body}');
      }
    } catch (e) {
      print('❌ Get feed error: $e');
      return [];
    }
  }

  // ========== ENTITY-SPECIFIC SYNC METHODS ==========

  // Item sync methods
  Future<Map<String, dynamic>> createItemBackend(
    Map<String, dynamic> data,
  ) async {
    try {
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
    } catch (e) {
      print('❌ Create item backend error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateItemBackend(
    int itemId,
    Map<String, dynamic> data,
  ) async {
    try {
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
    } catch (e) {
      print('❌ Update item backend error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteItemBackend(int itemId) async {
    try {
      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/items/$itemId'),
        method: 'DELETE',
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete item: ${response.body}');
      }
    } catch (e) {
      print('❌ Delete item backend error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Outfit sync methods
  Future<Map<String, dynamic>> createOutfitBackend(
    Map<String, dynamic> data,
  ) async {
    try {
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
    } catch (e) {
      print('❌ Create outfit backend error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateOutfitBackend(
    int outfitId,
    Map<String, dynamic> data,
  ) async {
    try {
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
    } catch (e) {
      print('❌ Update outfit backend error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteOutfitBackend(int outfitId) async {
    try {
      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/outfits/$outfitId'),
        method: 'DELETE',
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete outfit: ${response.body}');
      }
    } catch (e) {
      print('❌ Delete outfit backend error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Post sync methods
  Future<Map<String, dynamic>> createPostBackend(
    Map<String, dynamic> data,
  ) async {
    try {
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
    } catch (e) {
      print('❌ Create post backend error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePostBackend(
    int postId,
    Map<String, dynamic> data,
  ) async {
    try {
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
    } catch (e) {
      print('❌ Update post backend error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deletePostBackend(int postId) async {
    try {
      final response = await _authenticatedRequest(
        Uri.parse('$_baseUrl/posts/$postId'),
        method: 'DELETE',
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete post: ${response.body}');
      }
    } catch (e) {
      print('❌ Delete post backend error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // ========== HELPER METHODS ==========
  Future<http.Response> _authenticatedRequest(
    Uri url, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    if (_accessToken == null) {
      throw Exception('Not authenticated');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };

    print('🌐 API ${method.toUpperCase()}: $url');
    if (body != null) {
      print('📦 Request body: $body');
    }

    try {
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
          throw Exception('Unsupported HTTP method: $method');
      }
    } catch (e) {
      print('❌ API Request failed: $e');
      rethrow;
    }
  }

  // ========== PUBLIC PROPERTIES & METHODS ==========
  bool get isLoggedIn => _accessToken != null;
  int? get userId => _userId;

  static String get baseUrl => _baseUrl;

  Future<http.Response> authenticatedRequest(
    Uri url, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    return await _authenticatedRequest(url, method: method, body: body);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_id');

    _accessToken = null;
    _refreshToken = null;
    _userId = null;
  }

  // Token refresh method (optional)
  Future<bool> refreshToken() async {
    try {
      if (_refreshToken == null) return false;

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh_token': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', _accessToken!);

        return true;
      }
    } catch (e) {
      print('❌ Token refresh failed: $e');
    }
    return false;
  }
}
