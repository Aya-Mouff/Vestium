import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../data/dummy/dummy-data-loader.dart';

@RoutePage()
class EditOutfitScreen extends StatefulWidget {
  final String outfitId;

  const EditOutfitScreen({
    super.key,
    @PathParam('outfitId') required this.outfitId,
  });

  @override
  State<EditOutfitScreen> createState() => _EditOutfitScreenState();
}

class _EditOutfitScreenState extends State<EditOutfitScreen> {
  Map<String, dynamic>? outfit;
  Map<String, dynamic>? currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSeason;

  List<String> _userCategories = [];
  
  final List<String> _seasons = [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
    'All Season',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await DummyDataLoader.loadDummyData();
      final outfits = data['outfits'] as List<dynamic>;
      final users = data['users'] as List<dynamic>;

      // Get current user (user with id "1")
      final user = users.cast<Map<String, dynamic>?>().firstWhere(
        (u) => u?['id'].toString() == '1',
        orElse: () => null,
      );

      // Find the outfit by ID
      final foundOutfit = outfits.cast<Map<String, dynamic>?>().firstWhere(
        (o) => o?['id'].toString() == widget.outfitId,
        orElse: () => null,
      );

      if (foundOutfit != null && user != null) {
        // Get user's custom outfit categories
        final customCategories = user['customOutfitCategories'] as List<dynamic>?;
        
        setState(() {
          currentUser = user;
          outfit = foundOutfit;
          _userCategories = customCategories?.cast<String>().toList() ?? [
            'Casual',
            'Formal',
            'Streetwear',
            'Work',
            'Evening',
            'Vacation'
          ];
          
          // Populate form fields with outfit data
          _nameController.text = foundOutfit['name'] ?? '';
          _descriptionController.text = foundOutfit['description'] ?? '';
          _selectedCategory = foundOutfit['category'];
          
          // Handle season - could be string or array
          final season = foundOutfit['season'];
          if (season is String) {
            _selectedSeason = season == 'all' ? 'All Season' : _capitalizeFirstLetter(season);
          } else if (season is List && season.isNotEmpty) {
            _selectedSeason = _capitalizeFirstLetter(season[0].toString());
          }
        });
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void _saveChanges() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an outfit name'),
          backgroundColor: Color(0xFF795548),
        ),
      );
      return;
    }

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Color(0xFF795548),
        ),
      );
      return;
    }

    // Save changes to database/storage
    // For now, just show success and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Outfit updated successfully!'),
        backgroundColor: Color(0xFF795548),
      ),
    );

    // Navigate back to outfit details
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    if (outfit == null || currentUser == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5ECE7),
        body: Center(child: CircularProgressIndicator(
          color: Color(0xFF795548),
        )),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3E2723)),
          onPressed: () => context.router.maybePop(),
        ),
        title: const Text(
          'Outfit Details',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E2723),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Outfit Image
            Container(
              margin: const EdgeInsets.all(16),
              height: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF795548).withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  outfit!['imageUrl'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFD7CCC8),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Color(0xFF795548),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Edit Form
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Outfit Name
                  const Text(
                    'Outfit Name',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF3E2723),
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g., Summer Casual',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: const Color(0xFF795548).withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5ECE7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF795548),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF3E2723),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Perfect outfit for a casual summer day',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: const Color(0xFF795548).withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5ECE7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF795548),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Category
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5ECE7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        hint: Text(
                          'Select category',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                            color: const Color(0xFF795548).withValues(alpha: 0.5),
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF795548),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                          color: Color(0xFF3E2723),
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        items: _userCategories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Season
                  const Text(
                    'Season',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5ECE7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSeason,
                        hint: Text(
                          'Select season',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                            color: const Color(0xFF795548).withValues(alpha: 0.5),
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF795548),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                          color: Color(0xFF3E2723),
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        items: _seasons.map((String season) {
                          return DropdownMenuItem<String>(
                            value: season,
                            child: Text(season),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSeason = newValue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Buttons Row
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: TextButton(
                          onPressed: () => context.router.maybePop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Save Changes Button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF795548),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}