import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class SelectOutfitScreen extends StatefulWidget {
  const SelectOutfitScreen({super.key});

  @override
  State<SelectOutfitScreen> createState() => _SelectOutfitScreenState();
}

class _SelectOutfitScreenState extends State<SelectOutfitScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _selectedOutfit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      // Clear selection when switching tabs
      _selectedOutfit = null;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  // Dummy data for saved outfits
  final List<Map<String, dynamic>> savedOutfits = [
    {
      "id": "1",
      "userId": "1",
      "username": "fashion_lover",
      "profileImage": "assets/images/dummyData/profile-pic-women.jpg",
      "name": "Summer Casual",
      "description": "Perfect for Saturday brunches and casual outings",
      "season": "all",
      "category": "Casual",
      "createdAt": "2024-03-05T14:30:00Z",
      "items": ["1", "2"],
      "imageUrl": "assets/images/dummyData/casual-weekend-outfit.jpg",
      "daysAgo": "2 days ago"
    },
    {
      "id": "2",
      "userId": "1",
      "username": "fashion_lover",
      "profileImage": "assets/images/dummyData/profile-pic-women.jpg",
      "name": "Office Chic",
      "description": "Professional and stylish for the workplace",
      "season": "all",
      "category": "Formal",
      "createdAt": "2024-03-03T10:15:00Z",
      "items": ["3", "4"],
      "imageUrl": "assets/images/dummyData/casual-weekend-outfit.jpg", // Same image
      "daysAgo": "5 days ago"
    },
    {
      "id": "3",
      "userId": "1",
      "username": "fashion_lover",
      "profileImage": "assets/images/dummyData/profile-pic-women.jpg",
      "name": "Date Night",
      "description": "Elegant evening outfit for special occasions",
      "season": "all",
      "category": "Evening",
      "createdAt": "2024-03-01T18:20:00Z",
      "items": ["5", "6"],
      "imageUrl": "assets/images/dummyData/casual-weekend-outfit.jpg", // Same image
      "daysAgo": "1 week ago"
    },
    {
      "id": "4",
      "userId": "1",
      "username": "fashion_lover",
      "profileImage": "assets/images/dummyData/profile-pic-women.jpg",
      "name": "Casual Friday",
      "description": "Relaxed yet put-together for end of week",
      "season": "all",
      "category": "Casual",
      "createdAt": "2024-02-28T12:00:00Z",
      "items": ["7", "8"],
      "imageUrl": "assets/images/dummyData/casual-weekend-outfit.jpg", // Same image
      "daysAgo": "2 weeks ago"
    },
  ];

  // Dummy data for gallery
  final List<Map<String, dynamic>> galleryOutfits = [
    {
      "id": "5",
      "userId": "1",
      "username": "fashion_lover",
      "profileImage": "assets/images/dummyData/profile-pic-women.jpg",
      "name": "Beach Vibes",
      "description": "Light and breezy summer outfit",
      "season": "summer",
      "category": "Casual",
      "createdAt": "2024-02-25T09:30:00Z",
      "items": ["9", "10"],
      "imageUrl": "assets/images/dummyData/casual-weekend-outfit.jpg", // Same image
      "daysAgo": "3 weeks ago"
    },
    {
      "id": "6",
      "userId": "1",
      "username": "fashion_lover",
      "profileImage": "assets/images/dummyData/profile-pic-women.jpg",
      "name": "Winter Cozy",
      "description": "Warm and stylish for cold days",
      "season": "winter",
      "category": "Casual",
      "createdAt": "2024-02-20T16:45:00Z",
      "items": ["11", "12"],
      "imageUrl": "assets/images/dummyData/casual-weekend-outfit.jpg", // Same image
      "daysAgo": "1 month ago"
    },
    {
      "id": "7",
      "userId": "1",
      "username": "fashion_lover",
      "profileImage": "assets/images/dummyData/profile-pic-women.jpg",
      "name": "Sporty Chic",
      "description": "Athletic meets fashionable",
      "season": "all",
      "category": "Sporty",
      "createdAt": "2024-02-15T11:20:00Z",
      "items": ["13", "14"],
      "imageUrl": "assets/images/dummyData/casual-weekend-outfit.jpg", // Same image
      "daysAgo": "1 month ago"
    },
    {
      "id": "8",
      "userId": "1",
      "username": "fashion_lover",
      "profileImage": "assets/images/dummyData/profile-pic-women.jpg",
      "name": "Business Meeting",
      "description": "Professional power outfit",
      "season": "all",
      "category": "Formal",
      "createdAt": "2024-02-10T08:00:00Z",
      "items": ["15", "16"],
      "imageUrl": "assets/images/dummyData/casual-weekend-outfit.jpg", // Same image
      "daysAgo": "1 month ago"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Select Outfit',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(0);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 48,
                        decoration: BoxDecoration(
                          color: _tabController.index == 0
                              ? const Color(0xFFF5EDE8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: _tabController.index == 0
                              ? Border.all(color: const Color(0xFF8B6B5C), width: 1)
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark_outline,
                              size: 18,
                              color: _tabController.index == 0 
                                  ? const Color(0xFF8B6B5C)
                                  : Colors.grey[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Saved Outfits',
                              style: TextStyle(
                                fontSize: 14,
                                color: _tabController.index == 0 
                                    ? const Color(0xFF8B6B5C)
                                    : Colors.grey[700],
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(1);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 48,
                        decoration: BoxDecoration(
                          color: _tabController.index == 1
                              ? const Color(0xFFF5EDE8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: _tabController.index == 1
                              ? Border.all(color: const Color(0xFF8B6B5C), width: 1)
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: 18,
                              color: _tabController.index == 1 
                                  ? const Color(0xFF8B6B5C)
                                  : Colors.grey[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: 14,
                                color: _tabController.index == 1 
                                    ? const Color(0xFF8B6B5C)
                                    : Colors.grey[700],
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOutfitGrid(savedOutfits),
                _buildOutfitGrid(galleryOutfits),
              ],
            ),
          ),
          // Continue Button
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedOutfit != null ? () {
                  // Return the selected outfit
                  context.router.pop(_selectedOutfit);
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedOutfit != null 
                      ? const Color(0xFF8B6B5C) // Dark when selected
                      : const Color(0xFFC4B7AB), // Light when not selected
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitGrid(List<Map<String, dynamic>> outfits) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];
          final isSelected = _selectedOutfit != null && _selectedOutfit!['id'] == outfit['id'];
          return _buildOutfitCard(outfit, isSelected);
        },
      ),
    );
  }

  Widget _buildOutfitCard(Map<String, dynamic> outfit, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOutfit = isSelected ? null : outfit;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: isSelected 
              ? Border.all(color: const Color(0xFF8B6B5C), width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B6B5C).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: outfit['imageUrl'] != null
                      ? Image.asset(
                          outfit['imageUrl']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to a placeholder with the same image for all items
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.checkroom,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.checkroom,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    outfit['name'] ?? 'Untitled Outfit',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'CormorantGaramond',
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    outfit['daysAgo'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Inter',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}