import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/home_screen_cubit.dart';
import 'cubit/home_screen_state.dart';
import '../../widgets/nav_bar.dart';
import 'widgets/post_card.dart';
import '../../../app_router.dart';


@RoutePage()
class HomeScreen extends StatelessWidget {
  final int? userId;

  const HomeScreen({super.key, @PathParam('userId') required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Image.asset("assets/images/logos/logo.png"),
          title: const Text("Vestium", style: TextStyle(fontFamily: 'AlexBrush', fontSize: 25)),
          centerTitle: true,
          actions: [ 
            IconButton( 
              icon: const Icon(Icons.favorite_border, 
              color: Colors.black87), 
              onPressed: () { 
                // Navigate to notifications screen 
                context.router.push(NotificationsRoute(userId: userId)); 
              }, 
            ), 
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(child: Text(state.message));
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<HomeCubit>().loadPosts();
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(post: state.posts[index], userId: userId);
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),

        bottomNavigationBar: CustomNavBar(currentPage: 'home', userId: userId!),
      ),
    );
  }
}
