// wardrobe_grid_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/wardrobe_cubit.dart';
import '../cubit/wardrobe_state.dart';
import 'wardrobe_item_card.dart';

class WardrobeGridWidget extends StatelessWidget {
  const WardrobeGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WardrobeCubit, WardrobeState>(
      builder: (context, state) {
        return GridView.builder(
          // ADD bottom padding here only
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 13,
            childAspectRatio: 0.46, 
          ),
          itemCount: state.items.length,
          itemBuilder: (_, index) => WardrobeItemCard(item: state.items[index]),
        );
      },
    );
  }
}