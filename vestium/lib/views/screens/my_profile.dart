import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import '../widgets/nav_bar.dart';
import '../../data/dummy/dummy-data-loader.dart';

@RoutePage()
class MyProfileScreen extends StatefulWidget {
  final int userId;
  const MyProfileScreen({super.key, required this.userId});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Map<String, dynamic>? currentUser;
  List<dynamic> outfits = [];
  List<dynamic> filteredOutfits = [];
  List<dynamic> posts = [];
  bool showOutfits = false; // false => posts shown
  List<String> userOutfitCategories = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  } 

  Future<void> _loadUserData() async {
    final data = await DummyDataLoader.loadDummyData();
    final users = data['users'] as List<dynamic>;
    final outfitsData = data['outfits'] as List<dynamic>;
    final postsData = data['posts'] as List<dynamic>;

    // Get current user (you might want to get this from auth state instead of hardcoding)
    final current = users.firstWhere((u) => u['id'].toString() == '1');

    // Get ONLY this user's outfits
    final userOutfits = outfitsData
        .where((o) => o['userId'].toString() == '1')
        .toList();

    // Get ONLY this user's posts
    final userPosts = postsData
        .where((p) => p['userId'].toString() == '1')
        .toList();

    // Extract categories from THIS USER'S outfits only
    final categoriesFromUserOutfits = userOutfits
        .map<String>(
          (outfit) => outfit['category']?.toString() ?? 'Uncategorized',
        )
        .toSet() // Remove duplicates
        .toList();

    setState(() {
      currentUser = current;
      outfits = userOutfits;
      filteredOutfits = List.from(userOutfits);
      posts = userPosts;

      // Use categories from user's actual outfits, fallback to user's custom categories if none
      userOutfitCategories = categoriesFromUserOutfits.isNotEmpty
          ? categoriesFromUserOutfits
          : List<String>.from(current['customOutfitCategories'] ?? []);
    });
  }

  void _filterOutfitsByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredOutfits = List.from(outfits);
      } else {
        filteredOutfits = outfits
            .where((o) => o['category'] == category)
            .toList();
      }
    });
  }

  void _navigateToOutfitDetails(Map<String, dynamic> outfit) {
    context.router.pushNamed('/outfit-details/${outfit['id']}');
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          currentUser!['username'],
          style: const TextStyle(
            fontFamily: 'CormorantGaramend',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black87),
              onPressed: () {
                context.pushRoute(const AccountManagerRoute());
              },
            ),
          ),

          // Padding(
          //   padding: EdgeInsets.only(right: 16),
          //   child: Icon(Icons.settings_outlined, color: Colors.black87),
          // ),
        ],
      ),

      // Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Profile header
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(currentUser!['profileImage']),
            ),
            const SizedBox(height: 12),
            Text(
              currentUser!['fullName'],
              style: const TextStyle(
                fontFamily: 'CormorantGaramend',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              currentUser!['bio'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 16),

            // Stats row
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('Outfits', outfits.length.toString()),
                  _buildStat(
                    'Followers',
                    currentUser!['followersCount'].toString(),
                  ),
                  _buildStat(
                    'Following',
                    currentUser!['followingCount'].toString(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Edit profile button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9D9CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Posts / Outfits toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _buildToggleButton('Posts', !showOutfits),
                    _buildToggleButton('Outfits', showOutfits),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // If outfits view: show categories
            if (showOutfits) _buildFilterChips(),
            if (showOutfits) const SizedBox(height: 16),

            // Conditional content: Outfits grid OR Posts grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: showOutfits ? _buildOutfitsGrid() : _buildPostsGrid(),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // Floating add button (only when viewing outfits)
      floatingActionButton: showOutfits
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color(0xFF795548),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      bottomNavigationBar: CustomNavBar(currentPage: 'profile', userId: widget.userId),
    );
  }

  // Outfits grid (2 columns)
  Widget _buildOutfitsGrid() {
    if (filteredOutfits.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            selectedCategory == 'All'
                ? 'No outfits yet'
                : 'No outfits in $selectedCategory',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredOutfits.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final outfit = filteredOutfits[index];
        return GestureDetector(
          onTap: () => _navigateToOutfitDetails(outfit),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(outfit['imageUrl'], fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  // Posts grid (2 columns)
  Widget _buildPostsGrid() {
    if (posts.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No posts yet',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            context.router.pushNamed('/my_posts/${post['id']}');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(post['imageUrl'], fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String text, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            showOutfits = text == 'Outfits';
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF7B5247) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: active ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build filter chips dynamically
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildFilterChip('All', selectedCategory == 'All'),
          ...userOutfitCategories.map(
            (category) =>
                _buildFilterChip(category, selectedCategory == category),
          ),
          _buildAddCategoryChip(),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return GestureDetector(
      onTap: () => _filterOutfitsByCategory(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7B5247) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF7B5247), width: 0.8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: selected ? Colors.white : const Color(0xFF7B5247),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCategoryChip() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF7B5247), width: 0.8),
        ),
        child: const Icon(Icons.add, size: 16, color: Color(0xFF7B5247)),
      ),
    );
  }
}
