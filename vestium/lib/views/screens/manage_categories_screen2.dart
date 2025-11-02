import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../app_router.dart';


class Category {
  final String name;
  final int itemCount;

  Category({required this.name, required this.itemCount});
}


@RoutePage()
class ManageCategoriesScreen2 extends StatefulWidget {
  const ManageCategoriesScreen2({super.key});

  @override
  State<ManageCategoriesScreen2> createState() => _ManageCategoriesScreen2State();
}

class _ManageCategoriesScreen2State extends State<ManageCategoriesScreen2> {
  final TextEditingController _newCategoryController = TextEditingController();

  List<Category> categories = [
    Category(name: 'Casual', itemCount: 8),
    Category(name: 'Classic', itemCount: 5),
    Category(name: 'Formal', itemCount: 11),
    Category(name: 'Streetwear', itemCount: 3),
    Category(name: 'Work', itemCount: 2),
    Category(name: 'Vacation', itemCount: 9),
    Category(name: 'Evening', itemCount: 7),
  ];

  void _addCategory() {
    if (_newCategoryController.text.isNotEmpty) {
      setState(() {
        categories.add(
          Category(name: _newCategoryController.text, itemCount: 0),
        );
        _newCategoryController.clear();
      });
    }
  }

  void _editCategory(int index) {
    final controller = TextEditingController(text: categories[index].name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category', style: TextStyle(fontFamily: 'Inter', color: Colors.black)),
        content: TextField(
          controller: controller,
          style: const TextStyle(fontFamily: 'Inter', color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Category name',
            hintStyle: TextStyle(fontFamily: 'Inter', color: Color(0xFF795548)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Inter', color: Color(0xFF795548))),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  categories[index] = Category(
                    name: controller.text,
                    itemCount: categories[index].itemCount,
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(fontFamily: 'Inter', color: Color(0xFF795548))),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category', style: TextStyle(fontFamily: 'Inter', color: Colors.black)),
        content: Text(
          'Are you sure you want to delete "${categories[index].name}"?',
          style: const TextStyle(fontFamily: 'Inter', color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Inter', color: Color(0xFF795548))),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                categories.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Manage Categories For Outfits',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'CormorantGaramond',
          ),
        ),
      ),
      body: Column(
        children: [
          // Add new category section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DCD3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _newCategoryController,
                      style: const TextStyle(fontFamily: 'Inter', color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'New category name...',
                        hintStyle: TextStyle(
                          color: Color(0xFF795548),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF795548),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.add, color: Colors.white, size: 22),
                    onPressed: _addCategory,
                  ),
                ),
              ],
            ),
          ),

          // Categories list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categories[index].name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${categories[index].itemCount} items',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF795548),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: const Color(0xFF795548),
                        onPressed: () => _editCategory(index),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: Colors.red[400],
                        onPressed: () => _deleteCategory(index),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom info text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Categories help you organize your wardrobe items. Items can belong to multiple categories.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF795548),
                height: 1.3,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }
}
