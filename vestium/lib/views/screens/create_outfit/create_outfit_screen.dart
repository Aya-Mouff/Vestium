import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/databases/services/outfit_creation_service.dart';
//import 'package:vestium/databases/services/outfit_screenshot_service.dart';
import '../../../app_router.dart';
import './cubit/create_outfit_cubit.dart';
import './cubit/create_outfit_state.dart';
import './widgets/simple_zoom_item.dart';
import 'dart:ui' as ui; // Add this
import 'dart:io'; // Add this
import 'package:path/path.dart' as p; // Add this
import 'package:path_provider/path_provider.dart'; // Add this
import 'package:flutter/rendering.dart'; // Add this

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
  late CreateOutfitCubit _cubit;
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;

  // ✅ CANVAS KEY FOR SCREENSHOT CAPTURE
  final GlobalKey _canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    print('🎬 OutfitCreatorScreen initialized');
    print('   Canvas key created: $_canvasKey');

    _cubit = CreateOutfitCubit(userId: widget.userId);
    _transformationController.addListener(_onTransformChanged);

    if (widget.userId == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.router.replaceNamed('/access-denied');
      });
      return;
    }

    _cubit.loadClothingItems();
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onTransformChanged() {
    setState(() {
      _currentScale = _transformationController.value.getMaxScaleOnAxis();
    });
  }

  // void _handleSavePressed() async {
  //   print('\n💾 ============ SAVE BUTTON PRESSED ============');

  //   if (_cubit.state is CreateOutfitItemsLoaded) {
  //     final state = _cubit.state as CreateOutfitItemsLoaded;

  //     if (state.placedItems.isEmpty) {
  //       print('⚠️ No items in outfit');
  //       _showErrorSnackbar('Please add at least one item to the outfit');
  //       return;
  //     }

  //     print('📦 Preparing to save outfit with:');
  //     print('   - Items: ${state.placedItems.length}');
  //     print('   - Canvas key: $_canvasKey');

  //     // Show loading indicator
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const Center(
  //         child: Card(
  //           child: Padding(
  //             padding: EdgeInsets.all(24.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CircularProgressIndicator(),
  //                 SizedBox(height: 16),
  //                 Text('Capturing outfit...'),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     );

  //     // Wait a bit for any animations to settle
  //     await Future.delayed(const Duration(milliseconds: 300));

  //     String? capturedImagePath;

  //     try {
  //       // REMOVE THIS: Don't capture with temporary ID anymore
  //       // capturedImagePath = await OutfitScreenshotService.captureFullCanvas(
  //       //   canvasKey: _canvasKey,
  //       //   outfitId: 99999, // Temporary ID, will be replaced after save
  //       //   userId: widget.userId,
  //       //   quality: 3.0,
  //       // );

  //       // Instead, just capture and store temporarily
  //       print('📸 Capturing canvas screenshot...');

  //       final RenderRepaintBoundary boundary =
  //           _canvasKey.currentContext!.findRenderObject()
  //               as RenderRepaintBoundary;

  //       final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  //       if (byteData != null) {
  //         final buffer = byteData.buffer.asUint8List();
  //         final tempDir = await getTemporaryDirectory();
  //         capturedImagePath = p.join(
  //           tempDir.path,
  //           'outfit_temp_capture_${DateTime.now().millisecondsSinceEpoch}.png',
  //         );

  //         await File(capturedImagePath).writeAsBytes(buffer);
  //         print('✅ Canvas captured to temp file: $capturedImagePath');
  //       }
  //     } catch (e, stack) {
  //       print('❌ Error capturing screenshot: $e');
  //       print('Stack: $stack');
  //     }

  //     // Close loading dialog
  //     if (mounted) {
  //       Navigator.of(context).pop();
  //     }

  //     print('============ SCREENSHOT CAPTURE COMPLETE ============\n');

  //     // Store data
  //     OutfitCreationService.setCurrentOutfitData(
  //       cubit: _cubit,
  //       placedItems: state.placedItems,
  //       canvasKey: _canvasKey,
  //       capturedImagePath: capturedImagePath,
  //     );

  //     print('✅ Data stored in OutfitCreationService');
  //     print('============ NAVIGATING TO SAVE SCREEN ============\n');

  //     context.router.push(SaveOutfitRoute()).then((success) {
  //       if (success == true && mounted) {
  //         _showSuccessSnackbar('Outfit saved successfully!');
  //         Future.delayed(const Duration(seconds: 1), () {
  //           if (mounted) {
  //             context.router.maybePop();
  //             OutfitCreationService.clear();
  //           }
  //         });
  //       }
  //     });
  //   }
  // }

  void _handleSavePressed() async {
    print('\n💾 ============ SAVE BUTTON PRESSED ============');

    if (_cubit.state is CreateOutfitItemsLoaded) {
      final state = _cubit.state as CreateOutfitItemsLoaded;

      if (state.placedItems.isEmpty) {
        print('⚠️ No items in outfit');
        _showErrorSnackbar('Please add at least one item to the outfit');
        return;
      }

      print('📦 Preparing to save outfit with:');
      print('   - Items: ${state.placedItems.length}');
      print('   - Canvas key: $_canvasKey');

      // ✅ HIDE ZOOM INDICATORS BEFORE CAPTURING
      print('👁️  Hiding zoom indicators for screenshot...');
      SimpleZoomItem.hideZoomIndicators = true;

      // Force a rebuild of the canvas
      setState(() {});

      // Wait for UI to update
      await Future.delayed(const Duration(milliseconds: 50));

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Capturing outfit...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Wait a bit for any animations to settle
      await Future.delayed(const Duration(milliseconds: 300));

      String? capturedImagePath;

      try {
        print('📸 Capturing canvas screenshot...');

        final RenderRepaintBoundary boundary =
            _canvasKey.currentContext!.findRenderObject()
                as RenderRepaintBoundary;

        final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          final buffer = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          capturedImagePath = p.join(
            tempDir.path,
            'outfit_temp_capture_${DateTime.now().millisecondsSinceEpoch}.png',
          );

          await File(capturedImagePath).writeAsBytes(buffer);
          print('✅ Canvas captured to temp file: $capturedImagePath');
        }
      } catch (e, stack) {
        print('❌ Error capturing screenshot: $e');
        print('Stack: $stack');
      }

      // ✅ SHOW ZOOM INDICATORS AGAIN AFTER CAPTURING
      SimpleZoomItem.hideZoomIndicators = false;
      setState(() {}); // Force rebuild to show indicators again

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      print('============ SCREENSHOT CAPTURE COMPLETE ============\n');

      // Store data
      OutfitCreationService.setCurrentOutfitData(
        cubit: _cubit,
        placedItems: state.placedItems,
        canvasKey: _canvasKey,
        capturedImagePath: capturedImagePath,
      );

      print('✅ Data stored in OutfitCreationService');
      print('============ NAVIGATING TO SAVE SCREEN ============\n');

      context.router.push(SaveOutfitRoute()).then((success) {
        if (success == true && mounted) {
          _showSuccessSnackbar('Outfit saved successfully!');
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.router.maybePop();
              OutfitCreationService.clear();
            }
          });
        }
      });
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFF44336),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleZoomIn() {
    final newScale = (_currentScale * 1.2).clamp(0.5, 3.0);
    _transformationController.value = Matrix4.identity()..scale(newScale);
  }

  void _handleZoomOut() {
    final newScale = (_currentScale * 0.8).clamp(0.5, 3.0);
    _transformationController.value = Matrix4.identity()..scale(newScale);
  }

  void _handleResetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateOutfitCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF2C2C2C)),
            onPressed: () => context.router.maybePop(),
          ),
          title: const Text(
            'Create Outfit',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C2C2C),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.save_outlined, color: Color(0xFF2C2C2C)),
              onPressed: _handleSavePressed,
              tooltip: 'Save Outfit',
            ),
          ],
        ),
        body: BlocListener<CreateOutfitCubit, CreateOutfitState>(
          listener: (context, state) {
            if (state is CreateOutfitError) {
              _showErrorSnackbar(state.message);
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
                return _buildErrorState(state);
              }

              if (state is! CreateOutfitItemsLoaded) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6B5344)),
                );
              }

              return _buildMainContent(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(CreateOutfitError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(state.message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _cubit.loadClothingItems(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(CreateOutfitItemsLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = Size(
          constraints.maxWidth,
          constraints.maxHeight - 180,
        );

        return Column(
          children: [
            // Canvas Area
            Expanded(
              child: Stack(
                children: [
                  // Interactive Canvas with Items
                  GestureDetector(
                    onScaleStart: (details) {},
                    onScaleUpdate: (details) {
                      if (details.scale != 1.0) {
                        final newScale = (_currentScale * details.scale).clamp(
                          0.5,
                          3.0,
                        );
                        _transformationController.value = Matrix4.identity()
                          ..scale(newScale);
                      }
                    },
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: 0.5,
                      maxScale: 3.0,
                      panEnabled: true,
                      scaleEnabled: true,
                      child: RepaintBoundary(
                        // ✅ WRAP WITH RepaintBoundary
                        key: _canvasKey, // ✅ ADD THE KEY HERE
                        child: Container(
                          width: canvasSize.width,
                          height: canvasSize.height,
                          color: Colors.white,
                          child: Stack(
                            children: [
                              // Grid background
                              CustomPaint(
                                size: canvasSize,
                                painter: _GridPainter(),
                              ),
                              // Placed items
                              ...state.sortedPlacedItems.map((placedItem) {
                                return SimpleZoomItem(
                                  key: ValueKey('item_${placedItem.itemId}'),
                                  placedItem: placedItem,
                                  canvasSize: canvasSize,
                                  canvasScale: _currentScale,
                                  cubit: _cubit,
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Zoom controls
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: _buildZoomControls(),
                  ),

                  // Item counter
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            state.placedItems.isEmpty
                                ? Icons.layers_outlined
                                : Icons.layers,
                            size: 16,
                            color: const Color(0xFF6B5344),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${state.placedItems.length} items',
                            style: const TextStyle(
                              fontFamily: 'inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B5344),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Items List
            _buildBottomItemsList(state, canvasSize),
          ],
        );
      },
    );
  }

  Widget _buildZoomControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .1), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF2C2C2C)),
            onPressed: _handleZoomIn,
            tooltip: 'Zoom In',
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              '${(_currentScale * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B5344),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove, color: Color(0xFF2C2C2C)),
            onPressed: _handleZoomOut,
            tooltip: 'Zoom Out',
          ),
          const Divider(height: 1),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF2C2C2C)),
            onPressed: _handleResetZoom,
            tooltip: 'Reset',
          ),
        ],
      ),
    );
  }

  // Widget _buildBottomItemsList(CreateOutfitItemsLoaded state, Size canvasSize) {
  //   return Container(
  //     height: 180,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: .1),
  //           blurRadius: 8,
  //           offset: const Offset(0, -2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 'Your Items',
  //                 style: TextStyle(
  //                   fontFamily: 'CormorantGaramond',
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w600,
  //                   color: Color(0xFF2C2C2C),
  //                 ),
  //               ),
  //               Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 10,
  //                   vertical: 4,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFF5ECE7),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Text(
  //                   '${state.availableItems.length} total',
  //                   style: const TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w500,
  //                     color: Color(0xFF6B5344),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: state.availableItems.isEmpty
  //               ? const Center(
  //                   child: Text(
  //                     'No items in your wardrobe',
  //                     style: TextStyle(color: Color(0xFF999999)),
  //                   ),
  //                 )
  //               : ListView.separated(
  //                   scrollDirection: Axis.horizontal,
  //                   padding: const EdgeInsets.symmetric(horizontal: 16),
  //                   itemCount: state.availableItems.length,
  //                   separatorBuilder: (_, __) => const SizedBox(width: 12),
  //                   itemBuilder: (context, index) {
  //                     final item = state.availableItems[index];
  //                     final isInOutfit = state.placedItems.any(
  //                       (pi) => pi.itemId == item.itemId,
  //                     );

  //                     return GestureDetector(
  //                       onTap: () {
  //                         if (!isInOutfit) {
  //                           final position = Offset(
  //                             (canvasSize.width - 100) / 2,
  //                             (canvasSize.height - 120) / 2,
  //                           );
  //                           _cubit.addItemToOutfitWithPosition(item, position);
  //                         }
  //                       },
  //                       child: Container(
  //                         width: 80,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(12),
  //                           border: Border.all(
  //                             color: isInOutfit
  //                                 ? const Color(0xFF6B5344)
  //                                 : const Color(0xFFE0E0E0),
  //                             width: isInOutfit ? 2 : 1,
  //                           ),
  //                         ),
  //                         child: Stack(
  //                           children: [
  //                             ClipRRect(
  //                               borderRadius: BorderRadius.circular(12),
  //                               child: _buildItemImage(item.imagePath),
  //                             ),
  //                             if (isInOutfit)
  //                               Positioned(
  //                                 top: 4,
  //                                 right: 4,
  //                                 child: Container(
  //                                   padding: const EdgeInsets.all(4),
  //                                   decoration: const BoxDecoration(
  //                                     color: Color(0xFF6B5344),
  //                                     shape: BoxShape.circle,
  //                                   ),
  //                                   child: const Icon(
  //                                     Icons.check,
  //                                     size: 12,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //         ),
  //         const SizedBox(height: 8),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomItemsList(CreateOutfitItemsLoaded state, Size canvasSize) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Items',
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5ECE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${state.availableItems.length} total',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B5344),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.availableItems.isEmpty
                ? const Center(
                    child: Text(
                      'No items in your wardrobe',
                      style: TextStyle(color: Color(0xFF999999)),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.availableItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = state.availableItems[index];
                      final isInOutfit = state.placedItems.any(
                        (pi) => pi.itemId == item.itemId,
                      );

                      return GestureDetector(
                        onTap: () {
                          if (!isInOutfit) {
                            // ADD item to canvas
                            final position = Offset(
                              (canvasSize.width - 100) / 2,
                              (canvasSize.height - 120) / 2,
                            );
                            _cubit.addItemToOutfitWithPosition(item, position);
                          } else {
                            // ⭐ NEW: REMOVE item from canvas ⭐
                            if (item.itemId != null) {
                              _cubit.removeItemFromOutfit(item.itemId!);
                            }
                          }
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isInOutfit
                                  ? const Color(0xFF6B5344)
                                  : const Color(0xFFE0E0E0),
                              width: isInOutfit ? 2 : 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: _buildItemImage(item.imagePath),
                              ),
                              if (isInOutfit)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF6B5344),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildItemImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        color: const Color(0xFFF5ECE7),
        child: const Center(
          child: Icon(Icons.photo, color: Color(0xFFA1887F), size: 32),
        ),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFF5ECE7),
        child: const Center(
          child: Icon(Icons.broken_image, color: Color(0xFFA1887F), size: 32),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..strokeWidth = 0.5;

    const gridSize = 20.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
