// lib/wardrobe_screen/widgets/wardrobe_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/wardrobe_cubit.dart';
import '../cubit/wardrobe_state.dart';

class WardrobeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WardrobeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: BlocBuilder<WardrobeCubit, WardrobeState>(
        builder: (context, state) {
          return Column(
            children: [
              const Text(
                'My Wardrobe',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (state.selectedFilter != 'All')
                Text(
                  '${state.items.length} item${state.items.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          );
        },
      ),
      actions: [
        BlocBuilder<WardrobeCubit, WardrobeState>(
          builder: (context, state) {
            return IconButton(
              icon: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF8B6B61),
                      ),
                    )
                  : const Icon(Icons.refresh, color: Color(0xFF8B6B61)),
              onPressed: state.isLoading
                  ? null
                  : () => context.read<WardrobeCubit>().refresh(),
            );
          },
        ),
      ],
    );
  }
}