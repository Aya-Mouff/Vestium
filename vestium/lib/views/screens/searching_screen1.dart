// search_screen.dart
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // -----------------------------------------------------------------
  // 1. Shared data
  // -----------------------------------------------------------------
  final TextEditingController _searchController = TextEditingController();

  // Recent users (shown when search field is empty)
  final List<String> _recentUsers = ['style_guru', 'trend_setter', 'urban_style'];

  // Sample search results - Using data from JSON
  final List<Map<String, dynamic>> _searchResults = [
    {
      'id': '2',
      'username': 'style_guru',
      'fullName': 'Mike Chen',
      'bio': 'Street style photographer',
      'profileImage': 'assets/images/dummyData/profile-pic-men.png',
      'followersCount': 3,
      'followingCount': 1,
      'isFollowing': true,
    },
    {
      'id': '3',
      'username': 'trend_setter',
      'fullName': 'Emma Davis',
      'bio': 'Minimalist fashion | Sustainable clothing',
      'profileImage': 'assets/images/dummyData/profile-pic-women.jpg',
      'followersCount': 2,
      'followingCount': 3,
      'isFollowing': false,
    },
    {
      'id': '4',
      'username': 'urban_style',
      'fullName': 'Alex Rodriguez',
      'bio': 'Urban fashion lover',
      'profileImage': 'assets/images/dummyData/profile-pic-men.png',
      'followersCount': 2,
      'followingCount': 2,
      'isFollowing': true,
    },
  ];

  // -----------------------------------------------------------------
  // 2. Recent-list helpers
  // -----------------------------------------------------------------
  void _removeRecent(int index) => setState(() => _recentUsers.removeAt(index));

  void _deleteAllRecent() => setState(() => _recentUsers.clear());

  // -----------------------------------------------------------------
  // 3. Follow-button helper
  // -----------------------------------------------------------------
  void _toggleFollow(int index) {
    setState(() {
      _searchResults[index]['isFollowing'] = !_searchResults[index]['isFollowing'];
    });
  }

  // -----------------------------------------------------------------
  // 4. UI helpers
  // -----------------------------------------------------------------
  bool get _isSearching => _searchController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------------
  // 5. Build
  // -----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------------
            // Unified white header (Discover + Search bar)
            // -------------------------------------------------------
            Container(
              width: 412,
              height: 130,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'CormorantGaramond',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Search bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5ECE7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD7CCC8), width: 1),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}), // Trigger rebuild
                      style: const TextStyle(fontFamily: 'Inter', color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Search users, outfits, tags...',
                        hintStyle: TextStyle(color: Color(0xFF795548), fontSize: 14, fontFamily: 'Inter'),
                        prefixIcon: Icon(Icons.search, size: 20, color: Color(0xFF795548)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: _isSearching ? 16 : 24),

            // -------------------------------------------------------
            // Conditional body: Recent OR Results
            // -------------------------------------------------------
            if (!_isSearching) ...[
              _buildRecentHeader(),
              const SizedBox(height: 12),
              _buildRecentList(),
            ] else ...[
              _buildResultsList(),
            ],
          ],
        ),
      ),
          bottomNavigationBar: const CustomNavBar(currentPage: 'search'),

    );
  }

  // -----------------------------------------------------------------
  // Recent header
  // -----------------------------------------------------------------
  Widget _buildRecentHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Color(0xFF795548)),
              SizedBox(width: 8),
              Text(
                'Recent',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: 'Inter'),
              ),
            ],
          ),
          GestureDetector(
            onTap: _deleteAllRecent,
            child: const Text(
              'Delete all',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF795548),
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // Recent list
  // -----------------------------------------------------------------
  Widget _buildRecentList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _recentUsers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: 50.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD7CCC8), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Color(0xFF795548)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _recentUsers[index],
                        style: const TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Inter'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _removeRecent(index),
                      child: const Icon(Icons.close, size: 20, color: Color(0xFF795548)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // -----------------------------------------------------------------
  // Search-results list
  // -----------------------------------------------------------------
  Widget _buildResultsList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final user = _searchResults[index];
          final bool isFollowing = user['isFollowing'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              height: 74.09,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD7CCC8), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Profile picture
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color(0xFF795548),
                      backgroundImage: AssetImage(user['profileImage']),
                      child: user['profileImage'].isEmpty
                          ? Text(
                              user['username'][0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),

                    // Username + fullName
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user['username'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user['fullName'],
                            style: const TextStyle(fontSize: 13, color: Color(0xFF795548), fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ),

                    // Follow button
                    GestureDetector(
                      onTap: () => _toggleFollow(index),
                      child: Container(
                        width: 72.39,
                        height: 27.97,
                        decoration: BoxDecoration(
                          color: isFollowing ? Colors.transparent : const Color(0xFF795548),
                          borderRadius: BorderRadius.circular(20),
                          border: isFollowing ? Border.all(color: const Color(0xFF795548), width: 1.5) : null,
                        ),
                        child: Center(
                          child: Text(
                            isFollowing ? 'Following' : 'Follow',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isFollowing ? const Color(0xFF795548) : Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}