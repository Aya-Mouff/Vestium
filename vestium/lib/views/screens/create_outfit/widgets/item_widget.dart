// lib/views/screens/create_outfit/widgets/item_widget.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
//import '../placed_item_model.dart';
import 'package:vestium/databases/db_models.dart';

class ItemWidget extends StatelessWidget {
  final ItemModel item;
  final bool isSelected;
  final bool isDragging;

  const ItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isDragging,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF6B5344) : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: isDragging ? 12 : 8,
            spreadRadius: isDragging ? 1 : 0,
            offset: Offset(0, isDragging ? 4 : 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildItemImage(),
      ),
    );
  }

  Widget _buildItemImage() {
    if (item.imagePath == null || item.imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

    final imagePath = item.imagePath!;
    
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    } else {
      return FutureBuilder<bool>(
        future: _checkIfFileExists(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildPlaceholder();
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