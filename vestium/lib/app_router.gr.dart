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
    AccessDeniedRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccessDeniedScreen(),
      );
    },
    AccountManagerRoute.name: (routeData) {
      final args = routeData.argsAs<AccountManagerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AccountManagerScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    CameraAccessRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CameraAccessScreen(),
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
          orElse: () => CommentsRouteArgs(
                postId: pathParams.getInt('postId'),
                userId: pathParams.getInt('userId'),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CommentsScreen(
          key: args.key,
          postId: args.postId,
          userId: args.userId,
        ),
      );
    },
    EditItemRoute.name: (routeData) {
      final args = routeData.argsAs<EditItemRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditItemScreen(
          key: args.key,
          imagePath: args.imagePath,
        ),
      );
    },
    EditOutfitRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EditOutfitRouteArgs>(
          orElse: () =>
              EditOutfitRouteArgs(outfitId: pathParams.getString('outfitId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditOutfitScreen(
          key: args.key,
          outfitId: args.outfitId,
        ),
      );
    },
    FollowersRoute.name: (routeData) {
      final args = routeData.argsAs<FollowersRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FollowersScreen(
          key: args.key,
          userId: args.userId,
          currentUserId: args.currentUserId,
        ),
      );
    },
    FollowingRoute.name: (routeData) {
      final args = routeData.argsAs<FollowingRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FollowingScreen(
          key: args.key,
          userId: args.userId,
          currentUserId: args.currentUserId,
        ),
      );
    },
    GalleryAccessRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GalleryAccessScreen(),
      );
    },
    HelpCenterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HelpCenterScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HomeRouteArgs>(
          orElse: () => HomeRouteArgs(userId: pathParams.optInt('userId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomeScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    ItemDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<ItemDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ItemDetailsScreen(
          key: args.key,
          imagePath: args.imagePath,
        ),
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
      final args = routeData.argsAs<ManageCategoriesRoute2Args>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ManageCategoriesScreen2(
          key: args.key,
          userId: args.userId,
        ),
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
      final args = routeData.argsAs<MyProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MyProfileScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    NewPostRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NewPostRouteArgs>(
          orElse: () => NewPostRouteArgs(
                  userId: pathParams.getInt(
                'userId',
                -1,
              )));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NewPostScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    NotificationsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<NotificationsRouteArgs>(
          orElse: () =>
              NotificationsRouteArgs(userId: pathParams.optInt('userId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotificationsScreen(
          key: args.key,
          userId: args.userId,
        ),
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
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OutfitCreatorRouteArgs>(
          orElse: () =>
              OutfitCreatorRouteArgs(userId: pathParams.getInt('userId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OutfitCreatorScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    OutfitDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OutfitDetailsRouteArgs>(
          orElse: () => OutfitDetailsRouteArgs(
              outfitId: pathParams.getString('outfitId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OutfitDetailsScreen(
          key: args.key,
          outfitId: args.outfitId,
        ),
      );
    },
    PhotoPreviewRoute.name: (routeData) {
      final args = routeData.argsAs<PhotoPreviewRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PhotoPreviewScreen(
          key: args.key,
          imagePath: args.imagePath,
        ),
      );
    },
    PostsDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<PostsDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostsDetailsScreen(
          key: args.key,
          userId: args.userId,
          currentUserId: args.currentUserId,
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
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SearchRouteArgs>(
          orElse: () => SearchRouteArgs(userId: pathParams.getInt('userId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    SelectItemRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SelectItemScreen(),
      );
    },
    SelectOutfitRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SelectOutfitRouteArgs>(
          orElse: () => SelectOutfitRouteArgs(
                  userId: pathParams.getInt(
                'userId',
                -1,
              )));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SelectOutfitScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    SetNewPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SetNewPasswordScreen(),
      );
    },
    SettingsRoute1.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SettingsRoute1Args>(
          orElse: () =>
              SettingsRoute1Args(userId: pathParams.getInt('userId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SettingsScreen1(
          key: args.key,
          userId: args.userId,
        ),
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
    TakePicRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TakePicScreen(),
      );
    },
    UserProfileRoute.name: (routeData) {
      final args = routeData.argsAs<UserProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserProfileScreen(
          key: args.key,
          userId: args.userId,
          currentUserId: args.currentUserId,
        ),
      );
    },
    WardrobeRoute.name: (routeData) {
      final args = routeData.argsAs<WardrobeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WardrobeScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
  };
}

/// generated route for
/// [AccessDeniedScreen]
class AccessDeniedRoute extends PageRouteInfo<void> {
  const AccessDeniedRoute({List<PageRouteInfo>? children})
      : super(
          AccessDeniedRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccessDeniedRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountManagerScreen]
class AccountManagerRoute extends PageRouteInfo<AccountManagerRouteArgs> {
  AccountManagerRoute({
    Key? key,
    required int userId,
    List<PageRouteInfo>? children,
  }) : super(
          AccountManagerRoute.name,
          args: AccountManagerRouteArgs(
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'AccountManagerRoute';

  static const PageInfo<AccountManagerRouteArgs> page =
      PageInfo<AccountManagerRouteArgs>(name);
}

class AccountManagerRouteArgs {
  const AccountManagerRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'AccountManagerRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [CameraAccessScreen]
class CameraAccessRoute extends PageRouteInfo<void> {
  const CameraAccessRoute({List<PageRouteInfo>? children})
      : super(
          CameraAccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'CameraAccessRoute';

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
    required int postId,
    required int userId,
    List<PageRouteInfo>? children,
  }) : super(
          CommentsRoute.name,
          args: CommentsRouteArgs(
            key: key,
            postId: postId,
            userId: userId,
          ),
          rawPathParams: {
            'postId': postId,
            'userId': userId,
          },
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
    required this.userId,
  });

  final Key? key;

  final int postId;

  final int userId;

  @override
  String toString() {
    return 'CommentsRouteArgs{key: $key, postId: $postId, userId: $userId}';
  }
}

/// generated route for
/// [EditItemScreen]
class EditItemRoute extends PageRouteInfo<EditItemRouteArgs> {
  EditItemRoute({
    Key? key,
    required String imagePath,
    List<PageRouteInfo>? children,
  }) : super(
          EditItemRoute.name,
          args: EditItemRouteArgs(
            key: key,
            imagePath: imagePath,
          ),
          initialChildren: children,
        );

  static const String name = 'EditItemRoute';

  static const PageInfo<EditItemRouteArgs> page =
      PageInfo<EditItemRouteArgs>(name);
}

class EditItemRouteArgs {
  const EditItemRouteArgs({
    this.key,
    required this.imagePath,
  });

  final Key? key;

  final String imagePath;

  @override
  String toString() {
    return 'EditItemRouteArgs{key: $key, imagePath: $imagePath}';
  }
}

/// generated route for
/// [EditOutfitScreen]
class EditOutfitRoute extends PageRouteInfo<EditOutfitRouteArgs> {
  EditOutfitRoute({
    Key? key,
    required String outfitId,
    List<PageRouteInfo>? children,
  }) : super(
          EditOutfitRoute.name,
          args: EditOutfitRouteArgs(
            key: key,
            outfitId: outfitId,
          ),
          rawPathParams: {'outfitId': outfitId},
          initialChildren: children,
        );

  static const String name = 'EditOutfitRoute';

  static const PageInfo<EditOutfitRouteArgs> page =
      PageInfo<EditOutfitRouteArgs>(name);
}

class EditOutfitRouteArgs {
  const EditOutfitRouteArgs({
    this.key,
    required this.outfitId,
  });

  final Key? key;

  final String outfitId;

  @override
  String toString() {
    return 'EditOutfitRouteArgs{key: $key, outfitId: $outfitId}';
  }
}

/// generated route for
/// [FollowersScreen]
class FollowersRoute extends PageRouteInfo<FollowersRouteArgs> {
  FollowersRoute({
    Key? key,
    required int userId,
    required int currentUserId,
    List<PageRouteInfo>? children,
  }) : super(
          FollowersRoute.name,
          args: FollowersRouteArgs(
            key: key,
            userId: userId,
            currentUserId: currentUserId,
          ),
          initialChildren: children,
        );

  static const String name = 'FollowersRoute';

  static const PageInfo<FollowersRouteArgs> page =
      PageInfo<FollowersRouteArgs>(name);
}

class FollowersRouteArgs {
  const FollowersRouteArgs({
    this.key,
    required this.userId,
    required this.currentUserId,
  });

  final Key? key;

  final int userId;

  final int currentUserId;

  @override
  String toString() {
    return 'FollowersRouteArgs{key: $key, userId: $userId, currentUserId: $currentUserId}';
  }
}

/// generated route for
/// [FollowingScreen]
class FollowingRoute extends PageRouteInfo<FollowingRouteArgs> {
  FollowingRoute({
    Key? key,
    required int userId,
    required int currentUserId,
    List<PageRouteInfo>? children,
  }) : super(
          FollowingRoute.name,
          args: FollowingRouteArgs(
            key: key,
            userId: userId,
            currentUserId: currentUserId,
          ),
          initialChildren: children,
        );

  static const String name = 'FollowingRoute';

  static const PageInfo<FollowingRouteArgs> page =
      PageInfo<FollowingRouteArgs>(name);
}

class FollowingRouteArgs {
  const FollowingRouteArgs({
    this.key,
    required this.userId,
    required this.currentUserId,
  });

  final Key? key;

  final int userId;

  final int currentUserId;

  @override
  String toString() {
    return 'FollowingRouteArgs{key: $key, userId: $userId, currentUserId: $currentUserId}';
  }
}

/// generated route for
/// [GalleryAccessScreen]
class GalleryAccessRoute extends PageRouteInfo<void> {
  const GalleryAccessRoute({List<PageRouteInfo>? children})
      : super(
          GalleryAccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'GalleryAccessRoute';

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
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    Key? key,
    required int? userId,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<HomeRouteArgs> page = PageInfo<HomeRouteArgs>(name);
}

class HomeRouteArgs {
  const HomeRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final int? userId;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [ItemDetailsScreen]
class ItemDetailsRoute extends PageRouteInfo<ItemDetailsRouteArgs> {
  ItemDetailsRoute({
    Key? key,
    required String imagePath,
    List<PageRouteInfo>? children,
  }) : super(
          ItemDetailsRoute.name,
          args: ItemDetailsRouteArgs(
            key: key,
            imagePath: imagePath,
          ),
          initialChildren: children,
        );

  static const String name = 'ItemDetailsRoute';

  static const PageInfo<ItemDetailsRouteArgs> page =
      PageInfo<ItemDetailsRouteArgs>(name);
}

class ItemDetailsRouteArgs {
  const ItemDetailsRouteArgs({
    this.key,
    required this.imagePath,
  });

  final Key? key;

  final String imagePath;

  @override
  String toString() {
    return 'ItemDetailsRouteArgs{key: $key, imagePath: $imagePath}';
  }
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
class ManageCategoriesRoute2 extends PageRouteInfo<ManageCategoriesRoute2Args> {
  ManageCategoriesRoute2({
    Key? key,
    required int userId,
    List<PageRouteInfo>? children,
  }) : super(
          ManageCategoriesRoute2.name,
          args: ManageCategoriesRoute2Args(
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'ManageCategoriesRoute2';

  static const PageInfo<ManageCategoriesRoute2Args> page =
      PageInfo<ManageCategoriesRoute2Args>(name);
}

class ManageCategoriesRoute2Args {
  const ManageCategoriesRoute2Args({
    this.key,
    required this.userId,
  });

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'ManageCategoriesRoute2Args{key: $key, userId: $userId}';
  }
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
class MyProfileRoute extends PageRouteInfo<MyProfileRouteArgs> {
  MyProfileRoute({
    Key? key,
    required int userId,
    List<PageRouteInfo>? children,
  }) : super(
          MyProfileRoute.name,
          args: MyProfileRouteArgs(
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'MyProfileRoute';

  static const PageInfo<MyProfileRouteArgs> page =
      PageInfo<MyProfileRouteArgs>(name);
}

class MyProfileRouteArgs {
  const MyProfileRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'MyProfileRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [NewPostScreen]
class NewPostRoute extends PageRouteInfo<NewPostRouteArgs> {
  NewPostRoute({
    Key? key,
    int userId = -1,
    List<PageRouteInfo>? children,
  }) : super(
          NewPostRoute.name,
          args: NewPostRouteArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'NewPostRoute';

  static const PageInfo<NewPostRouteArgs> page =
      PageInfo<NewPostRouteArgs>(name);
}

class NewPostRouteArgs {
  const NewPostRouteArgs({
    this.key,
    this.userId = -1,
  });

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'NewPostRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [NotificationsScreen]
class NotificationsRoute extends PageRouteInfo<NotificationsRouteArgs> {
  NotificationsRoute({
    Key? key,
    required int? userId,
    List<PageRouteInfo>? children,
  }) : super(
          NotificationsRoute.name,
          args: NotificationsRouteArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const PageInfo<NotificationsRouteArgs> page =
      PageInfo<NotificationsRouteArgs>(name);
}

class NotificationsRouteArgs {
  const NotificationsRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final int? userId;

  @override
  String toString() {
    return 'NotificationsRouteArgs{key: $key, userId: $userId}';
  }
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
class OutfitCreatorRoute extends PageRouteInfo<OutfitCreatorRouteArgs> {
  OutfitCreatorRoute({
    Key? key,
    required int userId,
    List<PageRouteInfo>? children,
  }) : super(
          OutfitCreatorRoute.name,
          args: OutfitCreatorRouteArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'OutfitCreatorRoute';

  static const PageInfo<OutfitCreatorRouteArgs> page =
      PageInfo<OutfitCreatorRouteArgs>(name);
}

class OutfitCreatorRouteArgs {
  const OutfitCreatorRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'OutfitCreatorRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [OutfitDetailsScreen]
class OutfitDetailsRoute extends PageRouteInfo<OutfitDetailsRouteArgs> {
  OutfitDetailsRoute({
    Key? key,
    required String outfitId,
    List<PageRouteInfo>? children,
  }) : super(
          OutfitDetailsRoute.name,
          args: OutfitDetailsRouteArgs(
            key: key,
            outfitId: outfitId,
          ),
          rawPathParams: {'outfitId': outfitId},
          initialChildren: children,
        );

  static const String name = 'OutfitDetailsRoute';

  static const PageInfo<OutfitDetailsRouteArgs> page =
      PageInfo<OutfitDetailsRouteArgs>(name);
}

class OutfitDetailsRouteArgs {
  const OutfitDetailsRouteArgs({
    this.key,
    required this.outfitId,
  });

  final Key? key;

  final String outfitId;

  @override
  String toString() {
    return 'OutfitDetailsRouteArgs{key: $key, outfitId: $outfitId}';
  }
}

/// generated route for
/// [PhotoPreviewScreen]
class PhotoPreviewRoute extends PageRouteInfo<PhotoPreviewRouteArgs> {
  PhotoPreviewRoute({
    Key? key,
    required String imagePath,
    List<PageRouteInfo>? children,
  }) : super(
          PhotoPreviewRoute.name,
          args: PhotoPreviewRouteArgs(
            key: key,
            imagePath: imagePath,
          ),
          initialChildren: children,
        );

  static const String name = 'PhotoPreviewRoute';

  static const PageInfo<PhotoPreviewRouteArgs> page =
      PageInfo<PhotoPreviewRouteArgs>(name);
}

class PhotoPreviewRouteArgs {
  const PhotoPreviewRouteArgs({
    this.key,
    required this.imagePath,
  });

  final Key? key;

  final String imagePath;

  @override
  String toString() {
    return 'PhotoPreviewRouteArgs{key: $key, imagePath: $imagePath}';
  }
}

/// generated route for
/// [PostsDetailsScreen]
class PostsDetailsRoute extends PageRouteInfo<PostsDetailsRouteArgs> {
  PostsDetailsRoute({
    Key? key,
    required int userId,
    required int currentUserId,
    required int postId,
    List<PageRouteInfo>? children,
  }) : super(
          PostsDetailsRoute.name,
          args: PostsDetailsRouteArgs(
            key: key,
            userId: userId,
            currentUserId: currentUserId,
            postId: postId,
          ),
          initialChildren: children,
        );

  static const String name = 'PostsDetailsRoute';

  static const PageInfo<PostsDetailsRouteArgs> page =
      PageInfo<PostsDetailsRouteArgs>(name);
}

class PostsDetailsRouteArgs {
  const PostsDetailsRouteArgs({
    this.key,
    required this.userId,
    required this.currentUserId,
    required this.postId,
  });

  final Key? key;

  final int userId;

  final int currentUserId;

  final int postId;

  @override
  String toString() {
    return 'PostsDetailsRouteArgs{key: $key, userId: $userId, currentUserId: $currentUserId, postId: $postId}';
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
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    Key? key,
    required int userId,
    List<PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<SearchRouteArgs> page = PageInfo<SearchRouteArgs>(name);
}

class SearchRouteArgs {
  const SearchRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [SelectItemScreen]
class SelectItemRoute extends PageRouteInfo<void> {
  const SelectItemRoute({List<PageRouteInfo>? children})
      : super(
          SelectItemRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectItemRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SelectOutfitScreen]
class SelectOutfitRoute extends PageRouteInfo<SelectOutfitRouteArgs> {
  SelectOutfitRoute({
    Key? key,
    int userId = -1,
    List<PageRouteInfo>? children,
  }) : super(
          SelectOutfitRoute.name,
          args: SelectOutfitRouteArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'SelectOutfitRoute';

  static const PageInfo<SelectOutfitRouteArgs> page =
      PageInfo<SelectOutfitRouteArgs>(name);
}

class SelectOutfitRouteArgs {
  const SelectOutfitRouteArgs({
    this.key,
    this.userId = -1,
  });

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'SelectOutfitRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [SetNewPasswordScreen]
class SetNewPasswordRoute extends PageRouteInfo<void> {
  const SetNewPasswordRoute({List<PageRouteInfo>? children})
      : super(
          SetNewPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetNewPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsScreen1]
class SettingsRoute1 extends PageRouteInfo<SettingsRoute1Args> {
  SettingsRoute1({
    Key? key,
    required int userId,
    List<PageRouteInfo>? children,
  }) : super(
          SettingsRoute1.name,
          args: SettingsRoute1Args(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'SettingsRoute1';

  static const PageInfo<SettingsRoute1Args> page =
      PageInfo<SettingsRoute1Args>(name);
}

class SettingsRoute1Args {
  const SettingsRoute1Args({
    this.key,
    required this.userId,
  });

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'SettingsRoute1Args{key: $key, userId: $userId}';
  }
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
/// [TakePicScreen]
class TakePicRoute extends PageRouteInfo<void> {
  const TakePicRoute({List<PageRouteInfo>? children})
      : super(
          TakePicRoute.name,
          initialChildren: children,
        );

  static const String name = 'TakePicRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserProfileScreen]
class UserProfileRoute extends PageRouteInfo<UserProfileRouteArgs> {
  UserProfileRoute({
    Key? key,
    required int userId,
    required int currentUserId,
    List<PageRouteInfo>? children,
  }) : super(
          UserProfileRoute.name,
          args: UserProfileRouteArgs(
            key: key,
            userId: userId,
            currentUserId: currentUserId,
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
    required this.currentUserId,
  });

  final Key? key;

  final int userId;

  final int currentUserId;

  @override
  String toString() {
    return 'UserProfileRouteArgs{key: $key, userId: $userId, currentUserId: $currentUserId}';
  }
}

/// generated route for
/// [WardrobeScreen]
class WardrobeRoute extends PageRouteInfo<WardrobeRouteArgs> {
  WardrobeRoute({
    Key? key,
    required int userId,
    List<PageRouteInfo>? children,
  }) : super(
          WardrobeRoute.name,
          args: WardrobeRouteArgs(
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'WardrobeRoute';

  static const PageInfo<WardrobeRouteArgs> page =
      PageInfo<WardrobeRouteArgs>(name);
}

class WardrobeRouteArgs {
  const WardrobeRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'WardrobeRouteArgs{key: $key, userId: $userId}';
  }
}
