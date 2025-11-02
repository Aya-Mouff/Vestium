import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ItemDetailsScreen extends StatefulWidget {
  final String imagePath;

  const ItemDetailsScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedSeason;
  final Set<String> _selectedCategories = {};

  final List<String> _seasons = [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
    'All Season',
  ];

  final List<String> _categories = [
    'Tops',
    'Bottoms',
    'Dresses',
    'Outerwear',
    'Shoes',
    'Accessories',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addToWardrobe() {
    // Validate and save item
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an item name'),
          backgroundColor: Color(0xFF795548),
        ),
      );
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one category'),
          backgroundColor: Color(0xFF795548),
        ),
      );
      return;
    }

    // Save to database/storage
    // For now, just show success and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to wardrobe!'),
        backgroundColor: Color(0xFF795548),
      ),
    );

    // Navigate back to home or wardrobe screen
    context.router.popUntilRoot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.router.maybePop(),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF3E2723),
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Item Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3E2723),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24), // Spacer for alignment
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Preview
                    Container(
                      width: double.infinity,
                      height: 340,
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
                        child: Image.file(
                          File(widget.imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFD7CCC8),
                              child: const Center(
                                child: Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Color(0xFF795548),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Item Name
                    const Text(
                      'Item Name',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3E2723),
                        letterSpacing: 0.2,
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
                        hintText: 'e.g., Blue Denim Jacket',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                          color: const Color(0xFF795548).withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFFFFF),
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
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Description
                    const Text(
                      'Description (optional)',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3E2723),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: Color(0xFF3E2723),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add notes about this item...',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                          color: const Color(0xFF795548).withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFFFFF),
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
                          horizontal: 20,
                          vertical: 16,
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
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          dropdownColor: const Color(0xFFFFFFFF),
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

                    const SizedBox(height: 20),

                    // Categories
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3E2723),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategories.contains(category);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedCategories.remove(category);
                              } else {
                                _selectedCategories.add(category);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF795548)
                                  : const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF795548)
                                    : const Color(0xFFD7CCC8),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: isSelected
                                    ? const Color(0xFFFFFFFF)
                                    : const Color(0xFF795548),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Add to Wardrobe Button
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addToWardrobe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
                    foregroundColor: const Color(0xFFFFFFFF),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add to Wardrobe',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}