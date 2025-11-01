// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AccountManagerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountManagerScreen(),
      );
    },
    CheckEmailRoute.name: (routeData) {
      final args = routeData.argsAs<CheckEmailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CheckEmailScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
    CommentsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CommentsRouteArgs>(
          orElse: () =>
              CommentsRouteArgs(postId: pathParams.getString('postId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CommentsScreen(
          key: args.key,
          postId: args.postId,
        ),
      );
    },
    FollowersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FollowersScreen(),
      );
    },
    FollowingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FollowingScreen(),
      );
    },
    HelpCenterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HelpCenterScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    LogInRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LogInScreen(),
      );
    },
    ManageCategoriesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ManageCategoriesScreen(),
      );
    },
    ManageCategoriesRoute2.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ManageCategoriesScreen2(),
      );
    },
    MyPostsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<MyPostsRouteArgs>(
          orElse: () =>
              MyPostsRouteArgs(postId: pathParams.getString('postId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MyPostsScreen(
          key: args.key,
          postId: args.postId,
        ),
      );
    },
    MyProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyProfileScreen(),
      );
    },
    NewPostRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NewPostScreen(),
      );
    },
    NotificationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationsScreen(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingScreen(),
      );
    },
    OnboardingRoute2.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingScreen2(),
      );
    },
    OnboardingRoute3.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingScreen3(),
      );
    },
    OutfitCreatorRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OutfitCreatorScreen(),
      );
    },
    PostsDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PostsDetailsRouteArgs>(
          orElse: () =>
              PostsDetailsRouteArgs(postId: pathParams.getString('postId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostsDetailsScreen(
          key: args.key,
          postId: args.postId,
        ),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ResetPasswordScreen(),
      );
    },
    SearchRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchScreen(),
      );
    },
    SelectOutfitRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SelectOutfitScreen(),
      );
    },
    SetNewPassword.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SetNewPassword(),
      );
    },
    SettingsRoute1.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsScreen1(),
      );
    },
    SignUpRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignUpScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    UserProfileRoute.name: (routeData) {
      final args = routeData.argsAs<UserProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserProfileScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    WardrobeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WardrobeScreen(),
      );
    },
  };
}

/// generated route for
/// [AccountManagerScreen]
class AccountManagerRoute extends PageRouteInfo<void> {
  const AccountManagerRoute({List<PageRouteInfo>? children})
      : super(
          AccountManagerRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountManagerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CheckEmailScreen]
class CheckEmailRoute extends PageRouteInfo<CheckEmailRouteArgs> {
  CheckEmailRoute({
    Key? key,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
          CheckEmailRoute.name,
          args: CheckEmailRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'CheckEmailRoute';

  static const PageInfo<CheckEmailRouteArgs> page =
      PageInfo<CheckEmailRouteArgs>(name);
}

class CheckEmailRouteArgs {
  const CheckEmailRouteArgs({
    this.key,
    required this.email,
  });

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'CheckEmailRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [CommentsScreen]
class CommentsRoute extends PageRouteInfo<CommentsRouteArgs> {
  CommentsRoute({
    Key? key,
    required String postId,
    List<PageRouteInfo>? children,
  }) : super(
          CommentsRoute.name,
          args: CommentsRouteArgs(
            key: key,
            postId: postId,
          ),
          rawPathParams: {'postId': postId},
          initialChildren: children,
        );

  static const String name = 'CommentsRoute';

  static const PageInfo<CommentsRouteArgs> page =
      PageInfo<CommentsRouteArgs>(name);
}

class CommentsRouteArgs {
  const CommentsRouteArgs({
    this.key,
    required this.postId,
  });

  final Key? key;

  final String postId;

  @override
  String toString() {
    return 'CommentsRouteArgs{key: $key, postId: $postId}';
  }
}

/// generated route for
/// [FollowersScreen]
class FollowersRoute extends PageRouteInfo<void> {
  const FollowersRoute({List<PageRouteInfo>? children})
      : super(
          FollowersRoute.name,
          initialChildren: children,
        );

  static const String name = 'FollowersRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [FollowingScreen]
class FollowingRoute extends PageRouteInfo<void> {
  const FollowingRoute({List<PageRouteInfo>? children})
      : super(
          FollowingRoute.name,
          initialChildren: children,
        );

  static const String name = 'FollowingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HelpCenterScreen]
class HelpCenterRoute extends PageRouteInfo<void> {
  const HelpCenterRoute({List<PageRouteInfo>? children})
      : super(
          HelpCenterRoute.name,
          initialChildren: children,
        );

  static const String name = 'HelpCenterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LogInScreen]
class LogInRoute extends PageRouteInfo<void> {
  const LogInRoute({List<PageRouteInfo>? children})
      : super(
          LogInRoute.name,
          initialChildren: children,
        );

  static const String name = 'LogInRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ManageCategoriesScreen]
class ManageCategoriesRoute extends PageRouteInfo<void> {
  const ManageCategoriesRoute({List<PageRouteInfo>? children})
      : super(
          ManageCategoriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ManageCategoriesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ManageCategoriesScreen2]
class ManageCategoriesRoute2 extends PageRouteInfo<void> {
  const ManageCategoriesRoute2({List<PageRouteInfo>? children})
      : super(
          ManageCategoriesRoute2.name,
          initialChildren: children,
        );

  static const String name = 'ManageCategoriesRoute2';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyPostsScreen]
class MyPostsRoute extends PageRouteInfo<MyPostsRouteArgs> {
  MyPostsRoute({
    Key? key,
    required String postId,
    List<PageRouteInfo>? children,
  }) : super(
          MyPostsRoute.name,
          args: MyPostsRouteArgs(
            key: key,
            postId: postId,
          ),
          rawPathParams: {'postId': postId},
          initialChildren: children,
        );

  static const String name = 'MyPostsRoute';

  static const PageInfo<MyPostsRouteArgs> page =
      PageInfo<MyPostsRouteArgs>(name);
}

class MyPostsRouteArgs {
  const MyPostsRouteArgs({
    this.key,
    required this.postId,
  });

  final Key? key;

  final String postId;

  @override
  String toString() {
    return 'MyPostsRouteArgs{key: $key, postId: $postId}';
  }
}

/// generated route for
/// [MyProfileScreen]
class MyProfileRoute extends PageRouteInfo<void> {
  const MyProfileRoute({List<PageRouteInfo>? children})
      : super(
          MyProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NewPostScreen]
class NewPostRoute extends PageRouteInfo<void> {
  const NewPostRoute({List<PageRouteInfo>? children})
      : super(
          NewPostRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewPostRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationsScreen]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingScreen2]
class OnboardingRoute2 extends PageRouteInfo<void> {
  const OnboardingRoute2({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute2.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute2';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingScreen3]
class OnboardingRoute3 extends PageRouteInfo<void> {
  const OnboardingRoute3({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute3.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute3';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OutfitCreatorScreen]
class OutfitCreatorRoute extends PageRouteInfo<void> {
  const OutfitCreatorRoute({List<PageRouteInfo>? children})
      : super(
          OutfitCreatorRoute.name,
          initialChildren: children,
        );

  static const String name = 'OutfitCreatorRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PostsDetailsScreen]
class PostsDetailsRoute extends PageRouteInfo<PostsDetailsRouteArgs> {
  PostsDetailsRoute({
    Key? key,
    required String postId,
    List<PageRouteInfo>? children,
  }) : super(
          PostsDetailsRoute.name,
          args: PostsDetailsRouteArgs(
            key: key,
            postId: postId,
          ),
          rawPathParams: {'postId': postId},
          initialChildren: children,
        );

  static const String name = 'PostsDetailsRoute';

  static const PageInfo<PostsDetailsRouteArgs> page =
      PageInfo<PostsDetailsRouteArgs>(name);
}

class PostsDetailsRouteArgs {
  const PostsDetailsRouteArgs({
    this.key,
    required this.postId,
  });

  final Key? key;

  final String postId;

  @override
  String toString() {
    return 'PostsDetailsRouteArgs{key: $key, postId: $postId}';
  }
}

/// generated route for
/// [ResetPasswordScreen]
class ResetPasswordRoute extends PageRouteInfo<void> {
  const ResetPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchScreen]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SelectOutfitScreen]
class SelectOutfitRoute extends PageRouteInfo<void> {
  const SelectOutfitRoute({List<PageRouteInfo>? children})
      : super(
          SelectOutfitRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectOutfitRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SetNewPassword]
class SetNewPassword extends PageRouteInfo<void> {
  const SetNewPassword({List<PageRouteInfo>? children})
      : super(
          SetNewPassword.name,
          initialChildren: children,
        );

  static const String name = 'SetNewPassword';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsScreen1]
class SettingsRoute1 extends PageRouteInfo<void> {
  const SettingsRoute1({List<PageRouteInfo>? children})
      : super(
          SettingsRoute1.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute1';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserProfileScreen]
class UserProfileRoute extends PageRouteInfo<UserProfileRouteArgs> {
  UserProfileRoute({
    Key? key,
    required String userId,
    List<PageRouteInfo>? children,
  }) : super(
          UserProfileRoute.name,
          args: UserProfileRouteArgs(
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static const PageInfo<UserProfileRouteArgs> page =
      PageInfo<UserProfileRouteArgs>(name);
}

class UserProfileRouteArgs {
  const UserProfileRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserProfileRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [WardrobeScreen]
class WardrobeRoute extends PageRouteInfo<void> {
  const WardrobeRoute({List<PageRouteInfo>? children})
      : super(
          WardrobeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WardrobeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
