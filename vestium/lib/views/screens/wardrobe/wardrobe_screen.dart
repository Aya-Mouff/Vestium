// lib/wardrobe_screen/wardrobe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/views/widgets/nav_bar.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/views/screens/access_denied.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import './cubit/wardrobe_cubit.dart';
import './cubit/wardrobe_state.dart';
import 'widgets/wardrobe_grid_widget.dart';
import 'widgets/wardrobe_empty_state.dart';
import 'widgets/wardrobe_error_state.dart';
import 'widgets/wardrobe_app_bar.dart';

@RoutePage()
class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  late WardrobeCubit _wardrobeCubit;

  @override
  void initState() {
    super.initState();
    final userId = CurrentUserService.currentUserId ?? -1;
    _wardrobeCubit = WardrobeCubit(userId: userId);
  }

  @override
  void dispose() {
    _wardrobeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = CurrentUserService.currentUserId ?? -1;

    if (userId == -1) {
      return const AccessDeniedScreen();
    }

    return BlocProvider.value(
      value: _wardrobeCubit,
      child: _WardrobeContent(userId: userId),
    );
  }
}

class _WardrobeContent extends StatelessWidget {
  final int userId;

  const _WardrobeContent({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F2),
      appBar: const WardrobeAppBar(),
      extendBody: true,
      body: const _WardrobeBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF795548),
        onPressed: () => context.router.push(CameraAccessRoute()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // CRITICAL: Wrap with transparent container
      bottomNavigationBar: Container(
        color: Colors.transparent, // Makes it fully transparent
        child: CustomNavBar(
          currentPage: 'wardrobe',
          userId: userId,
        ),
      ),
    );
  }
}

class _WardrobeBody extends StatelessWidget {
  const _WardrobeBody();

  @override
  Widget build(BuildContext context) {
    // REMOVE ALL padding from here
    return BlocBuilder<WardrobeCubit, WardrobeState>(
      builder: (context, state) {
        if (state.errorMessage != null) {
          return WardrobeErrorState(errorMessage: state.errorMessage!);
        }

        if (state.isLoading && state.items.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF795548),
            ),
          );
        }

        if (state.items.isEmpty) {
          return WardrobeEmptyState(selectedFilter: state.selectedFilter);
        }

        return const WardrobeGridWidget();
      },
    );
  }
}