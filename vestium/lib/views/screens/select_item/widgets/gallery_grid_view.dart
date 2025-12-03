import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../gallery_access/cubit/gallery_access_cubit.dart';
import '../cubit/select_item_cubit.dart';

class GalleryGridView extends StatelessWidget {
  final List<Map<String, dynamic>> galleryItems;
  final Map<String, dynamic>? selectedItem;
  final Function(Map<String, dynamic>) onItemSelected;

  const GalleryGridView({
    super.key,
    required this.galleryItems,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (galleryItems.isEmpty) {
      return _buildEmptyGalleryView(context);
    }

    return _buildGalleryGrid();
  }

  Widget _buildEmptyGalleryView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'No Photos Selected',
              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3E2723),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tap the button below to select an image from your gallery',
              textAlign: TextAlign.center,
              style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E2723),
                    letterSpacing: 0.1,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _pickImageFromGallery(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B6B5C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Select from Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: galleryItems.length,
        itemBuilder: (context, index) {
          final galleryItem = galleryItems[index];
          final isSelected = selectedItem != null && 
              selectedItem!['id'] == galleryItem['id'];
          
          return _GalleryCard(
            galleryItem: galleryItem,
            isSelected: isSelected,
            onTap: () => onItemSelected(galleryItem),
          );
        },
      ),
    );
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final galleryCubit = context.read<GalleryAccessCubit>();
    final selectItemCubit = context.read<SelectItemCubit>();
    
    final imagePath = await galleryCubit.requestGalleryAccess();
    
    if (imagePath != null) {
      selectItemCubit.addGalleryItem(imagePath);
    }
  }
}

class _GalleryCard extends StatelessWidget {
  final Map<String, dynamic> galleryItem;
  final bool isSelected;
  final VoidCallback onTap;

  const _GalleryCard({
    required this.galleryItem,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: isSelected 
              ? Border.all(color: const Color(0xFF8B6B5C), width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0xFF8B6B5C).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12), bottom: Radius.circular(12)),
                child: _buildImageContent(),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         galleryItem['name'] ?? 'Gallery Image',
            //         style: const TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w600,
            //           fontFamily: 'CormorantGaramond',
            //           color: Colors.black87,
            //         ),
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //       const SizedBox(height: 4),
            //       Text(
            //         galleryItem['date'] ?? 'Recently added',
            //         style: TextStyle(
            //           fontSize: 12,
            //           fontFamily: 'Inter',
            //           color: Colors.grey[600],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    final filePath = galleryItem['filePath'] as String?;
    
    if (filePath != null) {
      return Image.file(
        File(filePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageErrorState();
        },
      );
    }

    return _buildImageErrorState();
  }

  Widget _buildImageErrorState() {
    return Container(
      color: Colors.grey[300],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 40,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'Failed to load',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}