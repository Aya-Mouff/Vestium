// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'cubit/my_profile_screen_cubit.dart';
// import 'widgets/profile_header.dart';
// import 'widgets/stats_row.dart';
// import 'widgets/posts_grid.dart';
// import 'widgets/outfits_grid.dart';
// import 'widgets/filter_chips.dart';
// import '../access_denied.dart';
// import 'cubit/my_profile_screen_state.dart';
// import 'package:auto_route/auto_route.dart';
// import '../../widgets/nav_bar.dart';
// import '../../../app_router.dart';

// @RoutePage()
// class MyProfileScreen extends StatelessWidget {
//   final int userId;
//   const MyProfileScreen({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => MyProfileCubit()..loadUserData(userId),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5ECE7),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//           title: BlocBuilder<MyProfileCubit, MyProfileState>(
//             builder: (context, state) {
//               if (state is MyProfileLoaded) {
//                 final username =
//                     (state.currentUser['username'] as String?) ?? 'User';
//                 return Text(
//                   username,
//                   style: const TextStyle(fontSize: 18, color: Colors.black),
//                 );
//               }
//               return const Text("");
//             },
//           ),
//           actions: [
//             BlocBuilder<MyProfileCubit, MyProfileState>(
//               builder: (context, state) {
//                 if (state is MyProfileLoaded) {
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 16),
//                     child: IconButton(
//                       icon: const Icon(
//                         Icons.settings_outlined,
//                         color: Colors.black87,
//                       ),
//                       onPressed: () {
//                         context.pushRoute(SettingsRoute1(userId: userId));
//                       },
//                     ),
//                   );
//                 }
//                 return const SizedBox();
//               },
//             ),
//           ],
//         ),
//         floatingActionButton: BlocBuilder<MyProfileCubit, MyProfileState>(
//           builder: (context, state) {
//             if (state is MyProfileLoaded && state.showOutfits) {
//               return FloatingActionButton(
//                 onPressed: () {
//                   context.pushRoute(OutfitCreatorRoute(userId: userId));
//                 },
//                 backgroundColor: const Color(0xFF7B5247),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 4,
//                 child: const Icon(Icons.add, size: 28),
//               );
//             }
//             return const SizedBox();
//           },
//         ),
//         body: BlocBuilder<MyProfileCubit, MyProfileState>(
//           builder: (context, state) {
//             if (state is MyProfileLoading || state is MyProfileInitial) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (state is MyProfileAccessDenied) {
//               return const AccessDeniedScreen();
//             }

//             if (state is MyProfileError) {
//               return Center(child: Text(state.message));
//             }

//             if (state is MyProfileLoaded) {
//               return RefreshIndicator(
//                 onRefresh: () async {
//                   await context.read<MyProfileCubit>().loadUserData(userId);
//                 },
//                 color: const Color(0xFF7B5247),
//                 backgroundColor: const Color(0xFFF5ECE7),
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 16),
//                       ProfileHeader(currentUser: state.currentUser),
//                       StatsRow(
//                         outfitsCount: state.outfits.length,
//                         followers: state.currentUser['followersCount'],
//                         following: state.currentUser['followingCount'],
//                         postsCount: state.posts.length,
//                         userId: userId,
//                       ),
//                       const SizedBox(height: 12),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             context.pushRoute(SettingsRoute1(userId: userId));
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFE9D9CF),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 0,
//                             minimumSize: const Size(double.infinity, 40),
//                             // Remove splash/ripple effect completely
//                             splashFactory: NoSplash.splashFactory,
//                             overlayColor: null, // Set to null instead
//                           ),
//                           child: const Text(
//                             'Edit Profile',
//                             style: TextStyle(
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () => context
//                                     .read<MyProfileCubit>()
//                                     .toggleView(false),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: !state.showOutfits
//                                         ? const Color(0xFF7B5247)
//                                         : Colors.transparent,
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'Posts',
//                                       style: TextStyle(
//                                         color: !state.showOutfits
//                                             ? Colors.white
//                                             : Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () => context
//                                     .read<MyProfileCubit>()
//                                     .toggleView(true),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: state.showOutfits
//                                         ? const Color(0xFF7B5247)
//                                         : Colors.transparent,
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'Outfits',
//                                       style: TextStyle(
//                                         color: state.showOutfits
//                                             ? Colors.white
//                                             : Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       if (state.showOutfits)
//                         FilterChips(
//                           categories: state.userOutfitCategories,
//                           selectedCategory: state.selectedCategory,
//                           userId: userId,
//                           onSelect: (category) => context
//                               .read<MyProfileCubit>()
//                               .filterOutfits(category),
//                         ),
//                       const SizedBox(height: 16),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: state.showOutfits
//                             ? OutfitsGrid(
//                                 outfits: state.filteredOutfits,
//                                 userId: userId,
//                               )
//                             : PostsGrid(posts: state.posts),
//                       ),
//                       const SizedBox(height: 80),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return const SizedBox();
//           },
//       ),
//       bottomNavigationBar: CustomNavBar(
//           currentPage: 'profile',
//           userId: userId,
//         ),
//       ),
//     );
//   }
// }

// =============================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/my_profile_screen_cubit.dart';
import 'widgets/profile_header.dart';
import 'widgets/stats_row.dart';
import 'widgets/posts_grid.dart';
import 'widgets/outfits_grid.dart';
import 'widgets/filter_chips.dart';
import '../access_denied.dart';
import 'cubit/my_profile_screen_state.dart';
import 'package:auto_route/auto_route.dart';
import '../../widgets/nav_bar.dart';
import '../../../app_router.dart';

@RoutePage()
class MyProfileScreen extends StatelessWidget {
  final int userId;
  const MyProfileScreen({super.key, required this.userId});

  // Navigate to OutfitCreator and refresh when returning
  Future<void> _navigateToCreateOutfit(BuildContext context) async {
    await context.pushRoute(OutfitCreatorRoute(userId: userId));
    
    // Refresh data when returning
    if (context.mounted) {
      print('🔄 Returned from outfit creator, refreshing...');
      context.read<MyProfileCubit>().loadUserData(userId);
    }
  }

  // Navigate to EditOutfit and refresh when returning
  Future<void> _navigateToEditOutfit(BuildContext context, int outfitId) async {
    await context.pushRoute(EditOutfitRoute(outfitId: outfitId));
    
    // Refresh data when returning
    if (context.mounted) {
      print('🔄 Returned from edit outfit, refreshing...');
      context.read<MyProfileCubit>().loadUserData(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyProfileCubit()..loadUserData(userId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: BlocBuilder<MyProfileCubit, MyProfileState>(
            builder: (context, state) {
              if (state is MyProfileLoaded) {
                final username =
                    (state.currentUser['username'] as String?) ?? 'User';
                return Text(
                  username,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                );
              }
              return const Text("");
            },
          ),
          actions: [
            BlocBuilder<MyProfileCubit, MyProfileState>(
              builder: (context, state) {
                if (state is MyProfileLoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        context.pushRoute(SettingsRoute1(userId: userId));
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<MyProfileCubit, MyProfileState>(
          builder: (context, state) {
            if (state is MyProfileLoaded && state.showOutfits) {
              return FloatingActionButton(
                onPressed: () => _navigateToCreateOutfit(context),
                backgroundColor: const Color(0xFF7B5247),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                child: const Icon(Icons.add, size: 28),
              );
            }
            return const SizedBox();
          },
        ),
        body: BlocBuilder<MyProfileCubit, MyProfileState>(
          builder: (context, state) {
            if (state is MyProfileLoading || state is MyProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MyProfileAccessDenied) {
              return const AccessDeniedScreen();
            }

            if (state is MyProfileError) {
              return Center(child: Text(state.message));
            }

            if (state is MyProfileLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<MyProfileCubit>().loadUserData(userId);
                },
                color: const Color(0xFF7B5247),
                backgroundColor: const Color(0xFFF5ECE7),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ProfileHeader(currentUser: state.currentUser),
                      StatsRow(
                        outfitsCount: state.outfits.length,
                        followers: state.currentUser['followersCount'],
                        following: state.currentUser['followingCount'],
                        postsCount: state.posts.length,
                        userId: userId,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton(
                          onPressed: () {
                            context.pushRoute(SettingsRoute1(userId: userId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE9D9CF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 40),
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: null,
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context
                                    .read<MyProfileCubit>()
                                    .toggleView(false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !state.showOutfits
                                        ? const Color(0xFF7B5247)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Posts',
                                      style: TextStyle(
                                        color: !state.showOutfits
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context
                                    .read<MyProfileCubit>()
                                    .toggleView(true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: state.showOutfits
                                        ? const Color(0xFF7B5247)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Outfits',
                                      style: TextStyle(
                                        color: state.showOutfits
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (state.showOutfits)
                        FilterChips(
                          categories: state.userOutfitCategories,
                          selectedCategory: state.selectedCategory,
                          userId: userId,
                          onSelect: (category) => context
                              .read<MyProfileCubit>()
                              .filterOutfits(category),
                        ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: state.showOutfits
                            ? OutfitsGrid(
                                outfits: state.filteredOutfits,
                                userId: userId,
                                onOutfitTap: (outfitId) => 
                                    _navigateToEditOutfit(context, outfitId),
                              )
                            : PostsGrid(posts: state.posts),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: CustomNavBar(
          currentPage: 'profile',
          userId: userId,
        ),
      ),
    );
  }
}