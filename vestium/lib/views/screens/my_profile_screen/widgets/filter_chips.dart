import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';

class FilterChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onSelect;
  final int userId;

  const FilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildChip('All', selectedCategory == 'All'),
          ...categories.map(
            (category) => _buildChip(category, selectedCategory == category),
          ),
          _buildAddCategoryChip(context),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool selected) {
    return GestureDetector(
      onTap: () => onSelect(label),
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
            fontSize: 13,
            color: selected ? Colors.white : const Color(0xFF7B5247),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCategoryChip(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF7B5247), width: 0.8),
        ),
        child: GestureDetector(
          onTap: () {
            context.pushRoute(ManageCategoriesRoute2(userId: userId));
          },
          child: const Icon(Icons.add, size: 16, color: Color(0xFF7B5247))
        ),
      ),
    );
  }
}
