import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vestium/views/screens/check_ur_email.dart';
import 'package:vestium/views/screens/reset_password.dart';
import 'package:vestium/views/screens/singup_screen.dart';
import './views/screens/splash_screen.dart';
import './views/screens/home_screen.dart';
import './views/screens/my_posts_screen.dart';
import './views/screens/posts_details_screen.dart';
import './views/screens/notifications_screen.dart';
import './views/screens/comments_screen.dart';

import 'views/screens/my_profile.dart';
import 'views/screens/login_screen.dart';
import './views/screens/reset_password.dart';
import './views/screens/set_new_password.dart';
import './views/screens/my_profile.dart';
import './views/screens/user_profile_screen.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/', initial: true),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: MyPostsRoute.page, path: '/my_posts/:postId'),
        AutoRoute(page: PostsDetailsRoute.page, path: '/posts_details/:postId'),
        AutoRoute(page: NotificationsRoute.page, path: '/notifications'),
        AutoRoute(page: CommentsRoute.page, path: '/comments/:postId'),

        AutoRoute(page: MyProfileRoute.page, path: '/my-profile'),

        AutoRoute(page: MyPostsRoute.page, path: '/my_posts'),
        AutoRoute(page: PostsDetailsRoute.page, path: '/posts_details'),
        AutoRoute(page: SignUpRoute.page , path:'/sign_up'),
        AutoRoute(page: LogInRoute.page , path: '/log_in'),
        AutoRoute(page: ResetPasswordRoute.page , path: '/reset_password' ),
        AutoRoute(page: CheckEmailRoute.page , path: '/check_email'),
       // AutoRoute(page: SetNewPasswordRoute.page )

        AutoRoute(page: MyProfileRoute.page, path: '/my_profile'),
        AutoRoute(page: UserProfileRoute.page, path: '/user_profile/:userId'),
      ];
}