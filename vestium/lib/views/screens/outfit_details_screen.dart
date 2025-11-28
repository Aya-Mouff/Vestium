import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../data/dummy/dummy-data-loader.dart';

@RoutePage()
class OutfitDetailsScreen extends StatefulWidget {
  final String outfitId;
  final int userId;

  const OutfitDetailsScreen({
    super.key,
    @PathParam('outfitId') required this.outfitId,
    @PathParam('userId') required this.userId,
  });

  @override
  State<OutfitDetailsScreen> createState() => _OutfitDetailsScreenState();
}

class _OutfitDetailsScreenState extends State<OutfitDetailsScreen> {
  Map<String, dynamic>? outfit;
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    _loadOutfitDetails();
  }

  // Future<void> _loadOutfitDetails() async {
  //   final data = await DummyDataLoader.loadDummyData();
  //   final outfits = data['outfits'] as List<dynamic>;
  //   final wardrobeItems = data['wardrobe'] as List<dynamic>;

  //   // Find the outfit by ID
  //   final foundOutfit = outfits.firstWhere(
  //     (o) => o['id'].toString() == widget.outfitId,
  //     orElse: () => null,
  //   );

  //   if (foundOutfit != null) {
  //     // Get the items that belong to this outfit
  //     final outfitItems = (foundOutfit['items'] as List<dynamic>?)
  //         ?.map((itemId) {
  //           return wardrobeItems.firstWhere(
  //             (item) => item['id'].toString() == itemId.toString(),
  //             orElse: () => null,
  //           );
  //         })
  //         .where((item) => item != null)
  //         .toList() ?? [];

  //     setState(() {
  //       outfit = foundOutfit;
  //       items = outfitItems;
  //     });
  //   }
  // }
  Future<void> _loadOutfitDetails() async {
    try {
      final data = await DummyDataLoader.loadDummyData();
      final outfits = data['outfits'] as List<dynamic>;
      final wardrobeItems = data['clothingItems'] as List<dynamic>;

      // Find the outfit by ID - SIMPLER APPROACH
      final foundOutfit = outfits.cast<Map<String, dynamic>?>().firstWhere(
        (o) => o?['id'].toString() == widget.outfitId,
        orElse: () => null,
      );

      if (foundOutfit != null) {
        // Get the items that belong to this outfit
        final List<dynamic> outfitItems = [];

        if (foundOutfit['items'] != null) {
          for (final itemId in (foundOutfit['items'] as List<dynamic>)) {
            final foundItem = wardrobeItems
                .cast<Map<String, dynamic>?>()
                .firstWhere(
                  (item) => item?['id'].toString() == itemId.toString(),
                  orElse: () => null,
                );
            if (foundItem != null) {
              outfitItems.add(foundItem);
            }
          }
        }

        setState(() {
          outfit = foundOutfit;
          items = outfitItems;
        });
      } else {
        // Outfit not found
        setState(() {
          outfit = {};
          items = [];
        });
      }
    } catch (e) {
      print('Error loading outfit details: $e');
      setState(() {
        outfit = {};
        items = [];
      });
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Delete Outfit?',
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to delete this outfit?\nThis action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Delete button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate back and show success message
                      context.router.maybePop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Outfit deleted'),
                          backgroundColor: Color(0xFF795548),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE7000B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Cancel button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
              ],
            ),
          ),
        );
      },
    );
  }

  void _shareOutfit() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality - Coming soon'),
        backgroundColor: Color(0xFF795548),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (outfit == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5ECE7),
        body: Center(child: CircularProgressIndicator()),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF3E2723)),
            onPressed: () {
              // Navigate to edit outfit screen
              context.router.pushNamed('/edit-outfit/${widget.outfitId}');
            },
          ),
        ],
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

            // Outfit Info Card
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
                  Text(
                    outfit!['name'] ?? 'Unnamed Outfit',
                    style: const TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  if (outfit!['description'] != null &&
                      outfit!['description'].toString().isNotEmpty)
                    Text(
                      outfit!['description'],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Created Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Color(0xFF795548),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        outfit!['createdDate'] ?? 'Created on October 20, 2025',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w200,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tags
                  if (outfit!['tags'] != null &&
                      (outfit!['tags'] as List).isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.label_outline,
                          size: 16,
                          color: Color(0xFF795548),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (outfit!['tags'] as List).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5ECE7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  tag.toString().startsWith('#')
                                      ? tag
                                      : '#$tag',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Items List
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
                  Text(
                    'Items (${items.length})',
                    style: const TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (items.isEmpty)
                    Center(
                      child: Text(
                        'No items in this outfit',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  else
                    ...items.map((item) => _buildItemCard(item)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Share Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _shareOutfit,
                  icon: const Icon(Icons.share_outlined, size: 20),
                  label: const Text(
                    'Share Outfit',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Delete Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _showDeleteDialog,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text(
                    'Delete Outfit',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFE7000B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5ECE7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Unnamed Item',
                  style: const TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['category'] ?? 'Uncategorized',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
