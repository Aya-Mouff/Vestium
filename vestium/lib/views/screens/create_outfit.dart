// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';

// @RoutePage()
// class OutfitCreatorScreen extends StatefulWidget {
//   final int userId;

//   const OutfitCreatorScreen({
//     super.key,
//     @PathParam('userId') required this.userId,
//   });


//   @override
//   State<OutfitCreatorScreen> createState() => _OutfitCreatorScreenState();
// }

// class _OutfitCreatorScreenState extends State<OutfitCreatorScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Check if user is a guest and redirect if so
//     if (widget.userId == -1) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         context.router.replaceNamed('/access-denied');
//       });
//     }
//   }

//   final List<String> selectedOutfitItems = [];
  
//   // Dummy clothing data - images from assets/images/dummyData
//   final List<Map<String, String>> clothingItems = [
//     {'id': '1', 'name': 'Black Jacket', 'image': 'assets/images/dummyData/cargo-pants.png'},
//     {'id': '2', 'name': 'Brown Pants', 'image': 'assets/images/dummyData/blue-jeans.png'},
//     {'id': '3', 'name': 'Blue Shirt', 'image': 'assets/images/dummyData/casual-weekend-outfit.jpg'},
//     {'id': '4', 'name': 'White Sneakers', 'image': 'assets/images/dummyData/cargo-pants.png'},
//     {'id': '5', 'name': 'Black Shoes', 'image': 'assets/images/dummyData/floral-summer-dress.png'},
//     {'id': '6', 'name': 'Gray Sweater', 'image': 'assets/images/dummyData/profile-pic-men.png'},
//     {'id': '7', 'name': 'Jeans', 'image': 'assets/images/dummyData/vintage-graphic-tee.png'},
//     {'id': '8', 'name': 'White Top', 'image': 'assets/images/dummyData/urban-outfit-streetstyle-outfit.jpg'},
//   ];

//   void _addItem(String itemImage) {
//     setState(() {
//       selectedOutfitItems.add(itemImage);
//     });
//     Navigator.pop(context);
//   }

//   void _removeItem(int index) {
//     setState(() {
//       selectedOutfitItems.removeAt(index);
//     });
//   }

//   void _showAddItemsDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         color: const Color(0xFFF5F1ED),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Select Items',
//                 style: TextStyle(
//                   fontFamily: 'CormorantGaramond',
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: const Color(0xFF2C2C2C),
//                 ),
                  
              
//               ),
//             ),
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(16),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemCount: clothingItems.length,
//                 itemBuilder: (context, index) {
//                   final item = clothingItems[index];
//                   return GestureDetector(
//                     onTap: () => _addItem(item['image']!),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: const Color(0xFFA1887F),
//                           width: 1.5,
//                         ),
//                         image: DecorationImage(
//                           image: AssetImage(item['image']!),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.black.withOpacity(0.3),
//                         ),
//                         child: Center(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.9),
//                               shape: BoxShape.circle,
//                             ),
//                             padding: const EdgeInsets.all(8),
//                             child: const Icon(
//                               Icons.add,
//                               color: Color(0xFF6B5344),
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5ECE7),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Color(0xFF2C2C2C)),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Outfit Creator',
//           style: TextStyle(
//             fontFamily: 'CormorantGaramond',
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF2C2C2C),
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save_outlined, color: Color(0xFF2C2C2C)),
//             onPressed: () {
//               // Save outfit functionality
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Outfit saved!')),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Outfit Display Area
//           Expanded(
//             child: Container(
//              margin: const EdgeInsets.all(15),
//              width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: selectedOutfitItems.isEmpty
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.layers_outlined,
//                           size: 60,
//                           color: Colors.grey[400],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Create Your Outfit',
//                           style: TextStyle(
//                             fontFamily: 'CormorantGaramond',
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF2C2C2C),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Tap the + button below to add items from\nyour wardrobe',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontFamily: 'inter',
//                             fontSize: 14,
//                             color: const Color(0xFF666666),
//                           ),
//                         ),
//                       ],
//                     )
//                   : SingleChildScrollView(
//                       padding: const EdgeInsets.all(16),
//                       child: Wrap(
//                         spacing: 12,
//                         runSpacing: 12,
//                         children: List.generate(
//                           selectedOutfitItems.length,
//                           (index) => GestureDetector(
//                             onLongPress: () => _removeItem(index),
//                             child: Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Image.asset(
//                                     selectedOutfitItems[index],
//                                     width: 100,
//                                     height: 120,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 4,
//                                   right: 4,
//                                   child: GestureDetector(
//                                     onTap: () => _removeItem(index),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.red,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       padding: const EdgeInsets.all(4),
//                                       child: const Icon(
//                                         Icons.close,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//             ),
//           ),
//           // Selected Items Preview
//           if (selectedOutfitItems.isNotEmpty)
//             Container(
//               height: 100,
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: selectedOutfitItems.length,
//                 itemBuilder: (context, index) => Padding(
//                   padding: const EdgeInsets.only(right: 12),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.asset(
//                       selectedOutfitItems[index],
//                       width: 80,
//                       height: 100,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           const SizedBox(height: 16),
//           // Add Items Button
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _showAddItemsDialog,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF6B5344),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   '+ Add Items',
//                   style: TextStyle(
//                     fontFamily: 'inter',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text(
//               'Tap and hold items to remove or tap + to add more',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'inter',
//                 fontSize: 12,
//                 color: const Color(0xFF999999),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OutfitCreatorScreen extends StatefulWidget {
  final int userId;

  const OutfitCreatorScreen({super.key, @PathParam('userId') required this.userId});

  @override
  State<OutfitCreatorScreen> createState() => _OutfitCreatorScreenState();
}

class PlacedItem {
  String image;
  double x;
  double y;

  PlacedItem({required this.image, required this.x, required this.y});
}

class _OutfitCreatorScreenState extends State<OutfitCreatorScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.userId == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.router.replaceNamed('/access-denied');
      });
    }
  }

  final List<PlacedItem> placedItems = [];

  final List<Map<String, String>> clothingItems = [
    {'id': '1', 'name': 'Black Jacket', 'image': 'assets/images/dummyData/cargo-pants.png'},
    {'id': '2', 'name': 'Brown Pants', 'image': 'assets/images/dummyData/blue-jeans.png'},
    {'id': '3', 'name': 'Blue Shirt', 'image': 'assets/images/dummyData/casual-weekend-outfit.jpg'},
  ];

  bool showItems = false;

  void _toggleAddItems() {
    setState(() {
      showItems = !showItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Color(0xFF2C2C2C)), onPressed: () => Navigator.pop(context)),
        title: Text('Outfit Creator', style: TextStyle(fontFamily: 'CormorantGaramond', fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFF2C2C2C))),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined, color: Color(0xFF2C2C2C)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Outfit saved!')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: showItems ? 7 : 10,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  margin: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: DragTarget<Map<String, String>>(
                    onAcceptWithDetails: (details) {
                      final local = (context.findRenderObject() as RenderBox).globalToLocal(details.offset);
                      setState(() {
                        // Clamp the positions so the item stays inside canvas
                        double newX = local.dx.clamp(0.0, constraints.maxWidth - 100);
                        double newY = local.dy.clamp(0.0, constraints.maxHeight - 100);
                        placedItems.add(PlacedItem(image: details.data['image']!, x: newX, y: newY));
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Stack(
                        children: placedItems.map((p) {
                          return Positioned(
                            left: p.x,
                            top: p.y,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  p.x = (p.x + details.delta.dx).clamp(0.0, constraints.maxWidth - 100);
                                  p.y = (p.y + details.delta.dy).clamp(0.0, constraints.maxHeight - 100);
                                });
                              },
                              child: Image.asset(p.image, width: 100),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (showItems)
            Expanded(
              flex: 3,
              child: Container(
                color: const Color(0xFFF5F1ED),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: clothingItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = clothingItems[index];
                    return Draggable<Map<String, String>>(
                      data: item,
                      feedback: Image.asset(item['image']!, width: 80),
                      childWhenDragging: Opacity(opacity: 0.4, child: Image.asset(item['image']!, width: 80)),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFA1887F), width: 1.5),
                          image: DecorationImage(image: AssetImage(item['image']!), fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleAddItems,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5344), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(showItems ? 'Hide Items' : '+ Add Items', style: TextStyle(fontFamily: 'inter', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
