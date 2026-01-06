import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/databases/services/outfit_creation_service.dart';
import 'cubit/save_outfit_cubit.dart';
import 'cubit/save_outfit_state.dart';
import 'widgets/outfit_name_field.dart';
import 'widgets/description_field.dart';
import 'widgets/season_selector.dart';
import 'widgets/category_selector.dart';
import 'widgets/items_count_display.dart';
import 'widgets/outfit_image_preview.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_cubit.dart';
import 'package:vestium/views/screens/create_outfit/cubit/create_outfit_state.dart';

@RoutePage()
class SaveOutfitScreen extends StatefulWidget {
  const SaveOutfitScreen({super.key});

  @override
  State<SaveOutfitScreen> createState() => _SaveOutfitScreenState();
}

class _SaveOutfitScreenState extends State<SaveOutfitScreen> {
  CreateOutfitCubit? _createOutfitCubit;
  List<PlacedItemModel>? _placedItems;
  String? _capturedImagePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // void _loadData() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _createOutfitCubit = OutfitCreationService.getCurrentCubit();
  //     _placedItems = OutfitCreationService.getCurrentPlacedItems();

  //     if (_createOutfitCubit == null || _placedItems == null) {
  //       print('❌ No outfit data found in service, navigating back');
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (mounted) {
  //           context.router.maybePop();
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content: Text('No outfit data found. Please create an outfit first.'),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
  //         }
  //       });
  //       return;
  //     }

  //     print('✅ Loaded ${_placedItems!.length} items from service');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createOutfitCubit = OutfitCreationService.getCurrentCubit();
      _placedItems = OutfitCreationService.getCurrentPlacedItems();
      _capturedImagePath = OutfitCreationService.getCapturedImagePath();

      if (_createOutfitCubit == null || _placedItems == null) {
        print('❌ No outfit data found in service, navigating back');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.router.maybePop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No outfit data found. Please create an outfit first.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
        return;
      }

      print('✅ Loaded ${_placedItems!.length} items from service');
      print(
        '✅ Captured image available: ${_capturedImagePath != null ? "YES ✅" : "NO ❌"}',
      );
      if (_capturedImagePath != null) {
        print('   Image path: $_capturedImagePath');
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF795548)),
        ),
      );
    }

    if (_createOutfitCubit == null || _placedItems == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red),
              SizedBox(height: 16),
              Text('No outfit data found', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    final createOutfitState = _createOutfitCubit!.state;

    if (createOutfitState is! CreateOutfitItemsLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF795548)),
        ),
      );
    }

    return BlocProvider(
      create: (context) => SaveOutfitCubit(
        createOutfitCubit: _createOutfitCubit!,
        placedItems: _placedItems!,
        canvasKey: OutfitCreationService.getCanvasKey(),
        preCapturedImagePath: _capturedImagePath, 
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        body: SafeArea(
          child: Column(
            children: [
              // Header - SAME DESIGN as item_details_header.dart
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        OutfitCreationService.clear();
                        context.router.maybePop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF3E2723),
                        size: 24,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Save Outfit',
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
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Outfit Preview - USING EXISTING OutfitImagePreview widget
                      OutfitImagePreview(
                        createOutfitCubit: _createOutfitCubit!,
                      ),
                      const SizedBox(height: 24),

                      // Outfit Name - USING EXISTING OutfitNameField widget
                      const OutfitNameField(),
                      const SizedBox(height: 20),

                      // Description - USING EXISTING DescriptionField widget
                      const DescriptionField(),
                      const SizedBox(height: 20),

                      // Season - USING EXISTING SeasonSelector widget
                      SeasonSelector(),
                      const SizedBox(height: 20),

                      // Categories - USING EXISTING CategorySelector widget
                      const CategorySelector(),
                      const SizedBox(height: 20),

                      // Items Count Display - USING EXISTING ItemsCountDisplay widget
                      ItemsCountDisplay(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Save Button - SAME DESIGN as add_to_wardrobe_button.dart
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: BlocListener<SaveOutfitCubit, SaveOutfitState>(
                  listener: (context, state) {
                    if (state is SaveOutfitError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    } else if (state is SaveOutfitSaved) {
                      OutfitCreationService.clear();
                    }
                  },
                  child: BlocBuilder<SaveOutfitCubit, SaveOutfitState>(
                    builder: (context, state) {
                      final isSaving =
                          state is SaveOutfitDataLoaded && state.isSaving;
                      final isValid =
                          state is SaveOutfitDataLoaded &&
                          state.outfitName.trim().isNotEmpty &&
                          state.itemsCount > 0;

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSaving || !isValid
                              ? null
                              : () async {
                                  final success = await context
                                      .read<SaveOutfitCubit>()
                                      .saveOutfit();
                                  if (success && context.mounted) {
                                    context.router.maybePop(true);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF795548),
                            foregroundColor: const Color(0xFFFFFFFF),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                )
                              : const Text(
                                  'Save to Wardrobe',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
