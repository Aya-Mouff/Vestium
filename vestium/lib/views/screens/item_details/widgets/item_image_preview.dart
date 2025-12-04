// import 'dart:io';
// import 'package:flutter/material.dart';

// class ItemImagePreview extends StatelessWidget {
//   final String imagePath;

//   const ItemImagePreview({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 340,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF795548).withValues(alpha: .15),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Image.file(
//           File(imagePath),
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               color: const Color(0xFFD7CCC8),
//               child: const Center(
//                 child: Icon(
//                   Icons.error_outline,
//                   size: 48,
//                   color: Color(0xFF795548),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// ======================================================================================

import 'dart:io';
import 'package:flutter/material.dart';

class ItemImagePreview extends StatelessWidget {
  final String imagePath;

  const ItemImagePreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF795548).withValues(alpha: .15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: FutureBuilder<bool>(
          future: _checkIfFileExists(imagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: const Color(0xFFD7CCC8),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF795548),
                  ),
                ),
              );
            }
            
            if (snapshot.hasError || !(snapshot.data ?? false)) {
              return Container(
                color: const Color(0xFFD7CCC8),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Color(0xFF795548),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Image not found',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(0xFF795548),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            return Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFD7CCC8),
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Color(0xFF795548),
                    ),
                  ),
                );
              },
            );
          },
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
