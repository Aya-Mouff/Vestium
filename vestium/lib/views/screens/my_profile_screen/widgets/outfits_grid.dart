import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'dart:io';

class OutfitsGrid extends StatelessWidget {
  final List<dynamic> outfits;
  final int userId;

  const OutfitsGrid({super.key, required this.outfits, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No outfits yet',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: outfits.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final outfit = outfits[index];
        final imagePath = outfit['imageUrl'];
        
        return GestureDetector(
          onTap: () => context.pushRoute(OutfitDetailsRoute(outfitId: outfit['id'])),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildOutfitImage(imagePath),
          ),
        );
      },
    );
  }

  Widget _buildOutfitImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFE9D9CF),
            child: const Center(
              child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 40),
            ),
          );
        },
      );
    } else {
      // File image
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFE9D9CF),
            child: const Center(
              child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 40),
            ),
          );
        },
      );
    }
  }
}

