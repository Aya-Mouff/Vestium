// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:io';
// import 'cubit/create_outfit_cubit.dart';
// import 'cubit/create_outfit_state.dart';
// import 'widgets/save_outfit_dialog.dart';

// /// Main Outfit Creator Screen
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
//   late CreateOutfitCubit _createOutfitCubit;
//   bool _showAvailableItems = false;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize cubit with userId
//     _createOutfitCubit = CreateOutfitCubit(userId: widget.userId);

//     if (widget.userId == -1) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         context.router.replaceNamed('/access-denied');
//       });
//       return;
//     }

//     // Load items from database
//     _createOutfitCubit.loadClothingItems();
//   }

//   @override
//   void dispose() {
//     _createOutfitCubit.close();
//     super.dispose();
//   }

//   void _handleSavePressed() {
//     showDialog(
//       context: context,
//       builder: (context) => SaveOutfitDialog(cubit: _createOutfitCubit),
//     ).then((success) {
//       if (success == true && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Outfit saved successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Future.delayed(const Duration(seconds: 1), () {
//           if (mounted) {
//             context.router.pop();
//           }
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _createOutfitCubit,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5ECE7),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.close, color: Color(0xFF2C2C2C)),
//             onPressed: () => context.router.pop(),
//           ),
//           title: const Text(
//             'Create Outfit',
//             style: TextStyle(
//               fontFamily: 'CormorantGaramond',
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF2C2C2C),
//             ),
//           ),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.save_outlined, color: Color(0xFF2C2C2C)),
//               onPressed: _handleSavePressed,
//             ),
//           ],
//         ),
//         body: BlocListener<CreateOutfitCubit, CreateOutfitState>(
//           listener: (context, state) {
//             if (state is CreateOutfitError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           child: BlocBuilder<CreateOutfitCubit, CreateOutfitState>(
//             builder: (context, state) {
//               if (state is CreateOutfitLoading) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: Color(0xFF6B5344)),
//                 );
//               }

//               if (state is CreateOutfitError) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.error_outline,
//                         size: 60,
//                         color: Colors.red,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(state.message, textAlign: TextAlign.center),
//                     ],
//                   ),
//                 );
//               }

//               if (state is! CreateOutfitItemsLoaded) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               return Column(
//                 children: [
//                   // Outfit display area
//                   Expanded(
//                     flex: _showAvailableItems ? 7 : 10,
//                     child: _buildOutfitCanvas(state),
//                   ),

//                   // Available items section
//                   if (_showAvailableItems)
//                     Expanded(flex: 3, child: _buildAvailableItemsGrid(state)),

//                   // Add items button
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _showAvailableItems = !_showAvailableItems;
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF6B5344),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           _showAvailableItems ? 'Hide Items' : '+ Add Items',
//                           style: const TextStyle(
//                             fontFamily: 'inter',
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOutfitCanvas(CreateOutfitItemsLoaded state) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Container(
//           margin: const EdgeInsets.all(15),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
//           ),
//           child: state.placedItems.isEmpty
//               ? _buildEmptyCanvas()
//               : Stack(
//                   children: state.placedItems.map((placedItem) {
//                     return Positioned(
//                       left: placedItem.position.dx,
//                       top: placedItem.position.dy,
//                       child: _buildPlacedItemCard(placedItem, constraints),
//                     );
//                   }).toList(),
//                 ),
//         );
//       },
//     );
//   }

//   Widget _buildEmptyCanvas() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.layers_outlined, size: 60, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           const Text(
//             'Create Your Outfit',
//             style: TextStyle(
//               fontFamily: 'CormorantGaramond',
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF2C2C2C),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Add items to create your perfect outfit',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: 'inter',
//               fontSize: 14,
//               color: Color(0xFF666666),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlacedItemCard(
//     PlacedItemModel placedItem,
//     BoxConstraints constraints,
//   ) {
//     return GestureDetector(
//       onLongPress: () {
//         context.read<CreateOutfitCubit>().removeItemFromOutfit(
//           placedItem.itemId,
//         );
//       },
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: SizedBox(
//               width: 100,
//               height: 120,
//               child: _buildItemImage(placedItem.item.imagePath),
//             ),
//           ),
//           Positioned(
//             top: 4,
//             right: 4,
//             child: GestureDetector(
//               onTap: () {
//                 context.read<CreateOutfitCubit>().removeItemFromOutfit(
//                   placedItem.itemId,
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.3),
//                       blurRadius: 4,
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(4),
//                 child: const Icon(Icons.close, color: Colors.white, size: 16),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Colors.black.withValues(alpha: 0.7),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(12),
//                   bottomRight: Radius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 placedItem.item.itemName ?? 'Item',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.white, fontSize: 10),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildItemImage(String? imagePath) {
//     if (imagePath != null && imagePath.isNotEmpty) {
//       return FutureBuilder<bool>(
//         future: _checkIfFileExists(imagePath),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               color: const Color(0xFFF5ECE7),
//               child: const Center(
//                 child: SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Color(0xFF795548),
//                   ),
//                 ),
//               ),
//             );
//           }

//           if (snapshot.data == true) {
//             return Image.file(
//               File(imagePath),
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: double.infinity,
//               errorBuilder: (context, error, stackTrace) {
//                 return _buildPlaceholder();
//               },
//             );
//           }

//           return _buildPlaceholder();
//         },
//       );
//     }
//     return _buildPlaceholder();
//   }

//   Widget _buildPlaceholder() {
//     return Container(
//       color: const Color(0xFFF5ECE7),
//       child: Center(
//         child: Icon(
//           Icons.photo,
//           size: 32,
//           color: const Color(0xFFA1887F).withValues(alpha: 0.5),
//         ),
//       ),
//     );
//   }

//   Future<bool> _checkIfFileExists(String path) async {
//     try {
//       final file = File(path);
//       return await file.exists();
//     } catch (e) {
//       return false;
//     }
//   }

//   Widget _buildAvailableItemsGrid(CreateOutfitItemsLoaded state) {
//     return Container(
//       color: const Color(0xFFF5F1ED),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Available Items',
//                   style: TextStyle(
//                     fontFamily: 'CormorantGaramond',
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2C2C2C),
//                   ),
//                 ),
//                 Text(
//                   '${state.availableItems.length} items',
//                   style: const TextStyle(
//                     fontFamily: 'inter',
//                     fontSize: 12,
//                     color: Color(0xFF999999),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: state.availableItems.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.inbox, size: 40, color: Colors.grey[400]),
//                         const SizedBox(height: 8),
//                         const Text('No items available'),
//                       ],
//                     ),
//                   )
//                 : GridView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 12,
//                           mainAxisSpacing: 12,
//                         ),
//                     itemCount: state.availableItems.length,
//                     itemBuilder: (context, index) {
//                       final item = state.availableItems[index];
//                       final isSelected = state.placedItems.any(
//                         (pi) => pi.itemId == item.itemId,
//                       );

//                       return GestureDetector(
//                         onTap: isSelected
//                             ? null
//                             : () {
//                                 context
//                                     .read<CreateOutfitCubit>()
//                                     .addItemToOutfit(item);
//                               },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: isSelected
//                                   ? const Color(0xFF6B5344)
//                                   : const Color(0xFFA1887F),
//                               width: isSelected ? 2 : 1.5,
//                             ),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Stack(
//                               children: [
//                                 _buildItemImage(item.imagePath),
//                                 if (isSelected)
//                                   Container(
//                                     color: Colors.black.withValues(alpha: 0.3),
//                                     child: const Center(
//                                       child: Icon(
//                                         Icons.check_circle,
//                                         color: Colors.white,
//                                         size: 28,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
// import 'dart:ui';
import 'cubit/create_outfit_cubit.dart';
import 'cubit/create_outfit_state.dart';
//import 'widgets/save_outfit_dialog.dart';
import '../../../databases/db_models.dart';
import '../../../app_router.dart';
import 'package:vestium/databases/services/outfit_creation_service.dart';

/// Main Outfit Creator Screen
@RoutePage()
class OutfitCreatorScreen extends StatefulWidget {
  final int userId;

  const OutfitCreatorScreen({
    super.key,
    @PathParam('userId') required this.userId,
  });

  @override
  State<OutfitCreatorScreen> createState() => _OutfitCreatorScreenState();
}

class _OutfitCreatorScreenState extends State<OutfitCreatorScreen> {
  late CreateOutfitCubit _createOutfitCubit;
  bool _showAvailableItems = false;

  @override
  void initState() {
    super.initState();

    // Initialize cubit with userId
    _createOutfitCubit = CreateOutfitCubit(userId: widget.userId);

    if (widget.userId == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.router.replaceNamed('/access-denied');
      });
      return;
    }

    // Load items from database
    _createOutfitCubit.loadClothingItems();
  }

  @override
  void dispose() {
    _createOutfitCubit.close();
    super.dispose();
  }

  // void _handleSavePressed() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => SaveOutfitDialog(cubit: _createOutfitCubit),
  //   ).then((success) {
  //     if (success == true && mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Outfit saved successfully!'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //       Future.delayed(const Duration(seconds: 1), () {
  //         if (mounted) {
  //           context.router.maybePop();
  //         }
  //       });
  //     }
  //   });
  // }

  void _handleSavePressed() {
    if (_createOutfitCubit.state is CreateOutfitItemsLoaded) {
      final state = _createOutfitCubit.state as CreateOutfitItemsLoaded;

      if (state.placedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one item to the outfit'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Store data in service before navigation
      OutfitCreationService.setCurrentOutfitData(
        cubit: _createOutfitCubit,
        placedItems: state.placedItems,
      );

      print(
        '📦 Navigating to SaveOutfitScreen with ${state.placedItems.length} items',
      );

      // Navigate to SaveOutfitScreen
      context.router
          .push(SaveOutfitRoute())
          .then((success) {
            if (success == true && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Outfit saved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  context.router.maybePop();
                  // Clear the service data after successful save
                  OutfitCreationService.clear();
                }
              });
            } else if (success == false) {
              // Save failed, keep data in service for retry
              print('⚠️ Save failed, keeping data in service for retry');
            }
          })
          .catchError((error) {
            print('❌ Navigation error: $error');
            // Clear service on error to prevent stale data
            OutfitCreationService.clear();
          });
    } else {
      print('❌ Invalid state for saving outfit');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot save outfit in current state'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _createOutfitCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF2C2C2C)),
            onPressed: () => context.router.maybePop(),
          ),
          title: const Text(
            'Create Outfit',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C2C2C),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.save_outlined, color: Color(0xFF2C2C2C)),
              onPressed: _handleSavePressed,
            ),
          ],
        ),
        body: BlocListener<CreateOutfitCubit, CreateOutfitState>(
          listener: (context, state) {
            if (state is CreateOutfitError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<CreateOutfitCubit, CreateOutfitState>(
            builder: (context, state) {
              if (state is CreateOutfitLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6B5344)),
                );
              }

              if (state is CreateOutfitError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(state.message, textAlign: TextAlign.center),
                    ],
                  ),
                );
              }

              if (state is! CreateOutfitItemsLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  // Outfit display area
                  Expanded(
                    flex: _showAvailableItems ? 7 : 10,
                    child: _buildOutfitCanvas(state, context),
                  ),

                  // Available items section
                  if (_showAvailableItems)
                    Expanded(flex: 3, child: _buildAvailableItemsList(state)),

                  // Add items button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showAvailableItems = !_showAvailableItems;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B5344),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _showAvailableItems ? 'Hide Items' : '+ Add Items',
                          style: const TextStyle(
                            fontFamily: 'inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOutfitCanvas(
    CreateOutfitItemsLoaded state,
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: DragTarget<ItemModel>(
            onAcceptWithDetails: (details) {
              final renderBox = context.findRenderObject() as RenderBox?;
              if (renderBox == null) return;

              final local = renderBox.globalToLocal(details.offset);

              // Clamp the positions so the item stays inside canvas
              double newX = local.dx.clamp(0.0, constraints.maxWidth - 100);
              double newY = local.dy.clamp(0.0, constraints.maxHeight - 120);

              // Check if item is already in outfit
              final isAlreadyAdded = state.placedItems.any(
                (pi) => pi.itemId == details.data.itemId,
              );

              if (!isAlreadyAdded) {
                context.read<CreateOutfitCubit>().addItemToOutfitWithPosition(
                  details.data,
                  Offset(newX, newY),
                );
              }
            },
            builder: (context, candidateData, rejectedData) {
              return state.placedItems.isEmpty
                  ? _buildEmptyCanvas()
                  : Stack(
                      children: state.placedItems.map((placedItem) {
                        return Positioned(
                          left: placedItem.position.dx,
                          top: placedItem.position.dy,
                          child: Draggable<PlacedItemModel>(
                            data: placedItem,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: .3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _buildItemImage(
                                    placedItem.item.imagePath,
                                  ),
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.4,
                              child: _buildPlacedItemCard(
                                placedItem,
                                constraints,
                                context,
                              ),
                            ),
                            onDragEnd: (details) {
                              if (details.offset.dx >= 0 &&
                                  details.offset.dy >= 0 &&
                                  details.offset.dx <= constraints.maxWidth &&
                                  details.offset.dy <= constraints.maxHeight) {
                                // Calculate new position
                                double newX = details.offset.dx.clamp(
                                  0.0,
                                  constraints.maxWidth - 100,
                                );
                                double newY = details.offset.dy.clamp(
                                  0.0,
                                  constraints.maxHeight - 120,
                                );

                                context
                                    .read<CreateOutfitCubit>()
                                    .updateItemPosition(
                                      placedItem.itemId!,
                                      Offset(newX, newY),
                                    );
                              }
                            },
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                // Update position during drag
                                double newX =
                                    (placedItem.position.dx + details.delta.dx)
                                        .clamp(0.0, constraints.maxWidth - 100);
                                double newY =
                                    (placedItem.position.dy + details.delta.dy)
                                        .clamp(
                                          0.0,
                                          constraints.maxHeight - 120,
                                        );

                                context
                                    .read<CreateOutfitCubit>()
                                    .updateItemPosition(
                                      placedItem.itemId!,
                                      Offset(newX, newY),
                                    );
                              },
                              child: _buildPlacedItemCard(
                                placedItem,
                                constraints,
                                context,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyCanvas() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.layers_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Drag items here to create your outfit',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacedItemCard(
    PlacedItemModel placedItem,
    BoxConstraints constraints,
    BuildContext context,
  ) {
    return GestureDetector(
      onLongPress: () {
        context.read<CreateOutfitCubit>().removeItemFromOutfit(
          placedItem.itemId,
        );
      },
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildItemImage(placedItem.item.imagePath),
        ),
      ),
    );
  }

  Widget _buildAvailableItemsList(CreateOutfitItemsLoaded state) {
    return Container(
      color: const Color(0xFFF5F1ED),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.availableItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = state.availableItems[index];
          final isSelected = state.placedItems.any(
            (pi) => pi.itemId == item.itemId,
          );

          return Draggable<ItemModel>(
            data: item,
            feedback: Material(
              color: Colors.transparent,
              child: Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF6B5344), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildItemImage(item.imagePath),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.4,
              child: Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6B5344)
                        : const Color(0xFFA1887F),
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      _buildItemImage(item.imagePath),
                      if (isSelected)
                        Container(
                          color: Colors.black.withValues(alpha: .3),
                          child: const Center(
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            child: GestureDetector(
              onTap: isSelected
                  ? null
                  : () {
                      context.read<CreateOutfitCubit>().addItemToOutfit(item);
                    },
              child: Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6B5344)
                        : const Color(0xFFA1887F),
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      _buildItemImage(item.imagePath),
                      if (isSelected)
                        Container(
                          color: Colors.black.withValues(alpha: .3),
                          child: const Center(
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return FutureBuilder<bool>(
        future: _checkIfFileExists(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: const Color(0xFFF5ECE7),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF795548),
                  ),
                ),
              ),
            );
          }

          if (snapshot.data == true) {
            return Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder();
              },
            );
          }

          return _buildPlaceholder();
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5ECE7),
      child: Center(
        child: Icon(
          Icons.photo,
          size: 32,
          color: const Color(0xFFA1887F).withValues(alpha: .5),
        ),
      ),
    );
  }

  Future<bool> _checkIfFileExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}
