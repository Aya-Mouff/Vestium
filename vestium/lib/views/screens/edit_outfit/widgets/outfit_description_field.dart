// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/edit_outfit_cubit.dart';
// import '../cubit/edit_outfit_state.dart';

// class OutfitDescriptionField extends StatelessWidget {
//   const OutfitDescriptionField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Description',
//           style: TextStyle(
//             fontFamily: 'CormorantGaramond',
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: Color(0xFF3E2723),
//           ),
//         ),
//         const SizedBox(height: 8),
//         BlocBuilder<EditOutfitCubit, EditOutfitState>(
//           builder: (context, state) {
//             return TextField(
//               onChanged: (value) => context.read<EditOutfitCubit>().updateDescription(value),
//               controller: TextEditingController(text: state.description),
//               maxLines: 3,
//               style: const TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 15,
//                 fontWeight: FontWeight.w200,
//                 color: Color(0xFF3E2723),
//               ),
//               decoration: InputDecoration(
//                 hintText: 'Perfect outfit for a casual summer day',
//                 hintStyle: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 15,
//                   fontWeight: FontWeight.w200,
//                   color: const Color(0xFF795548).withValues(alpha: .5),
//                 ),
//                 filled: true,
//                 fillColor: const Color(0xFFF5ECE7),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide.none,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: const BorderSide(
//                     color: Color(0xFF795548),
//                     width: 1.5,
//                   ),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 14,
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_outfit_cubit.dart';
import '../cubit/edit_outfit_state.dart';

class OutfitDescriptionField extends StatefulWidget {
  const OutfitDescriptionField({super.key});

  @override
  State<OutfitDescriptionField> createState() => _OutfitDescriptionFieldState();
}

class _OutfitDescriptionFieldState extends State<OutfitDescriptionField> {
  late TextEditingController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E2723),
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<EditOutfitCubit, EditOutfitState>(
          builder: (context, state) {
            // Initialize controller only once with the loaded data
            // Also handle empty description on first load
            if (!_isInitialized && !state.isLoading) {
              _controller.text = state.description;
              _isInitialized = true;
            }

            return TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<EditOutfitCubit>().updateDescription(value);
              },
              maxLines: 3,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w200,
                color: Color(0xFF3E2723),
              ),
              decoration: InputDecoration(
                hintText: 'Perfect outfit for a casual summer day',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: const Color(0xFF795548).withValues(alpha: .5),
                ),
                filled: true,
                fillColor: const Color(0xFFF5ECE7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF795548),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}