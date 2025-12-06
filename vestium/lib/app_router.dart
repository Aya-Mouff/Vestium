import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vestium/views/screens/account_manager.dart';
import 'package:vestium/views/screens/check_email_screen/check_email_page.dart';
import 'package:vestium/views/screens/create_outfit.dart';
import 'package:vestium/views/screens/reset_password_screen/reset_password_page.dart';
import 'package:vestium/views/screens/signup_screen/signup_page.dart';
// import 'package:vestium/views/screens/outfit_details_screen.dart';
import 'package:vestium/views/screens/outfit_details/outfit_details_screen.dart';
// import 'package:vestium/views/screens/camera_permisssion_screen.dart';
import 'package:vestium/views/screens/camera_access/camera_access_screen.dart';
// import 'package:vestium/views/screens/gallery_permissison_screen.dart';
import 'package:vestium/views/screens/gallery_access/gallery_access_screen.dart';
// import 'package:vestium/views/screens/take_pic_screen.dart';
import 'package:vestium/views/screens/take_pic/take_pic_screen.dart';
// import 'package:vestium/views/screens/photo_preview_screen.dart';
import 'package:vestium/views/screens/photo_preview/photo_preview_screen.dart';
// import 'package:vestium/views/screens/edit_item_screen.dart';
import 'package:vestium/views/screens/edit_item/edit_item_screen.dart';
// import 'package:vestium/views/screens/item_details_screen.dart';
import 'package:vestium/views/screens/item_details/item_details_screen.dart';
// import 'package:vestium/views/screens/edit_outfit_screen.dart';
import 'package:vestium/views/screens/edit_outfit/edit_outfit_screen.dart';
import 'package:vestium/views/screens/select_item/select_item_screen.dart';
import './views/screens/splash_screen.dart';
import 'views/screens/home_screen/home_screen.dart';
import 'views/screens/my_posts_screen/my_posts_screen.dart';
import 'views/screens/posts_details_screen/posts_details_screen.dart';
import 'views/screens/notifications_screen/notifications_screen.dart';
import 'views/screens/comments_screen/comments_screen.dart';
import 'views/screens/login_screen/login_page.dart';
import 'views/screens/user_Profile_screen/user_profile_screen.dart';
import 'views/screens/help_center_screen/help_center_page.dart';
import 'views/screens/my_profile_screen/my_profile.dart';
import './views/screens/onboarding_screen1.dart';
import './views/screens/onboarding_screen2.dart';
import './views/screens/onboarding_screen3.dart';
import './views/screens/manage_categories_screen1.dart';
import './views/screens/manage_categories_screen2.dart';
import './views/screens/settings_screen/settings_screen1.dart';
import './views/screens/searching_screen/searching_screen1.dart';
import './views/screens/followers_screen/followers_screen.dart';
import './views/screens/following_screen/following_screen.dart';
import './views/screens/new_post_screen/new_post_screen.dart';
import './views/screens/select_outfit/select_outfit_screen.dart';
// import './views/screens/wardrobe_screen.dart';
import 'package:vestium/views/screens/wardrobe/wardrobe_screen.dart';
import 'views/screens/set_new_password_screen.dart';
import 'views/screens/access_denied.dart';
import 'package:vestium/views/screens/edit_item_details/edit_item_details_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, path: '/', initial: true),
    AutoRoute(page: HomeRoute.page, path: '/home/:userId'),
    AutoRoute(page: MyPostsRoute.page, path: '/my_posts/:postId'),
    AutoRoute(page: NotificationsRoute.page, path: '/notifications/:userId'),
    AutoRoute(page: CommentsRoute.page, path: '/comments/:postId/:userId'),
    AutoRoute(page: MyPostsRoute.page, path: '/my_posts'),
    AutoRoute(
      page: PostsDetailsRoute.page,
      path: '/posts_details/:postId/:userId/:currentUserId',
    ),
    AutoRoute(page: SignUpRoute.page, path: '/sign_up'),
    AutoRoute(page: LogInRoute.page, path: '/log_in'),
    AutoRoute(page: ResetPasswordRoute.page, path: '/reset_password'),
    AutoRoute(page: CheckEmailRoute.page, path: '/check_email'),
    AutoRoute(page: SetNewPasswordRoute.page, path: '/set_new_password'),
    AutoRoute(page: MyProfileRoute.page, path: '/my_profile/:userId'),
    AutoRoute(
      page: UserProfileRoute.page,
      path: '/user_profile/:userId/:currentUserId',
    ),
    AutoRoute(page: AccountManagerRoute.page, path: '/account_manager/:userId'),
    AutoRoute(page: HelpCenterRoute.page, path: '/help_center'),
    AutoRoute(page: OutfitCreatorRoute.page, path: '/create_outfit/:userId'),
    AutoRoute(
      page: OutfitDetailsRoute.page,
      // path: '/outfit-details/:outfitId/:userId',
    ),
    AutoRoute(page: CameraAccessRoute.page),
    AutoRoute(page: TakePicRoute.page),
    AutoRoute(page: GalleryAccessRoute.page),
    AutoRoute(page: PhotoPreviewRoute.page),
    AutoRoute(page: EditItemRoute.page),
    AutoRoute(page: ItemDetailsRoute.page),
    AutoRoute(page: EditOutfitRoute.page, path: '/edit-outfit/:outfitId'),
    AutoRoute(page: OnboardingRoute.page, path: '/onboarding1'),
    AutoRoute(page: OnboardingRoute2.page, path: '/onboarding2'),
    AutoRoute(page: OnboardingRoute3.page, path: '/onboarding3'),
    AutoRoute(page: ManageCategoriesRoute.page, path: '/manage_categories1/:userId'),
    AutoRoute(
      page: ManageCategoriesRoute2.page,
      path: '/manage_categories2/:userId',
    ),
    AutoRoute(page: SettingsRoute1.page, path: '/settings1/:userId'),
    AutoRoute(page: SearchRoute.page, path: '/search1/:userId'),
    AutoRoute(page: FollowersRoute.page, path: '/followers1/:userId/:currentUserId'),
    AutoRoute(page: FollowingRoute.page, path: '/following1/:userId/:currentUserId'),
    AutoRoute(page: NewPostRoute.page, path: '/newpost/:userId'),
    AutoRoute(page: SelectOutfitRoute.page, path: '/selectoutfit/:userId'),
    AutoRoute(page: SelectItemRoute.page, ),
    AutoRoute(page: NewPostRoute.page, path: '/newpost/:userId'),
    AutoRoute(page: SelectOutfitRoute.page, path: '/selectoutfit'),
    AutoRoute(page: WardrobeRoute.page, path: '/wardrobe/:userId'),
    AutoRoute(page: AccessDeniedRoute.page, path: '/access-denied'),
    AutoRoute(page: EditItemDetailsRoute.page, path: '/edit-item/:itemId'),
  ];
}
