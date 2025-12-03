// lib/wardrobe_screen.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../widgets/nav_bar.dart';
import 'access_denied.dart';

@RoutePage()
/// ---------------------------------------------------------------
///  WardrobeScreen – pure front-end demo
/// ---------------------------------------------------------------
class WardrobeScreen extends StatefulWidget {
  final int userId;

  const WardrobeScreen({super.key, required this.userId});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  Widget build(BuildContext context) {
    // Check if user is a guest and return AccessDeniedScreen
    if (widget.userId == -1) {
      return const AccessDeniedScreen();
    }

    return _WardrobeContent(userId: widget.userId);
  }
}

class _WardrobeContent extends StatefulWidget {
  final int userId;
  const _WardrobeContent({required this.userId});

  @override
  State<_WardrobeContent> createState() => _WardrobeContentState();
}

class _WardrobeContentState extends State<_WardrobeContent> {
  // ---------- filter state ----------
  String selected = 'All';

  // 3 text tags + the + icon tag
  final List<Map<String, dynamic>> filters = [
    {'label': 'All', 'icon': null},
    {'label': 'Tops', 'icon': null},
    {'label': 'Bottoms', 'icon': null},
    {'label': null, 'icon': Icons.add}, // + icon only
  ];

  // ---------- dummy items ----------
  final String demoImg = 'assets/images/dummyData/casual-weekend-outfit.jpg';
  final List<Map<String, String>> items = [
    {'img': 'assets/images/dummyData/casual-weekend-outfit.jpg', 'name': 'Denim Jacket', 'cat': 'Outerwear'},
    {'img': 'assets/images/dummyData/casual-weekend-outfit.jpg', 'name': 'White T-Shirt', 'cat': 'Tops'},
    {'img': 'assets/images/dummyData/casual-weekend-outfit.jpg', 'name': 'Black Jeans', 'cat': 'Bottoms'},
    {'img': 'assets/images/dummyData/casual-weekend-outfit.jpg', 'name': 'Summer Dress', 'cat': 'Dresses'},
    {'img': 'assets/images/dummyData/casual-weekend-outfit.jpg', 'name': 'Sneakers', 'cat': 'Shoes'},
    {'img': 'assets/images/dummyData/casual-weekend-outfit.jpg', 'name': 'Leather Bag', 'cat': 'Accessories'},
  ];

  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Wardrobe',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),

      // ---------- Body ----------
      body: Column(
        children: [
          // ----- scrollable filter pills -----
          SizedBox(
            height: 50,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (_, i) {
                final f = filters[i];
                final label = f['label'] as String?;
                final icon = f['icon'] as IconData?;
                final isSelected = selected == (label ?? '+');

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selected = label ?? '+');
                      if (icon == Icons.add) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add item (demo)')),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: label != null ? 16 : 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF8B6B61)
                            : const Color(0xFFF0E4DC),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // + icon tag
                          if (icon != null) ...[
                            Icon(
                              icon,
                              size: 16,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF8B6B61),
                            ),
                          ]
                          // text tags
                          else ...[
                            if (isSelected)
                              const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                            else
                              const SizedBox(width: 4),
                            const SizedBox(width: 4),
                            Text(
                              label!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF8B6B61),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ----- grid -----
          Expanded(child: _grid(selected == 'All' ? null : selected)),
        ],
      ),

      // ---------- floating + ----------
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B6B61),
        onPressed: () => setState(() => selected = '+'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
       bottomNavigationBar: CustomNavBar(currentPage: 'wardrobe', userId: widget.userId),
    );
    
  }

  // ---------------------------------------------------------------
  Widget _grid(String? cat) {
    final list = (cat == null || cat == '+')
        ? items
        : items.where((e) => e['cat'] == cat).toList();

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: list.length,
      itemBuilder: (_, i) => _card(list[i]),
    );
  }

  // ---------------------------------------------------------------
  Widget _card(Map<String, String> it) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              it['img']!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          it['name']!,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          it['cat']!,
          style: TextStyle(fontSize: 12, color: Colors.brown.shade600),
        ),
      ],
    );
  }
}