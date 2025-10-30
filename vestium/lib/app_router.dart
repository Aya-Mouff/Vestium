import 'package:auto_route/auto_route.dart';
import './views/screens/splash_screen.dart';
import './views/screens/home_screen.dart';
import './views/screens/my_posts_screen.dart';
import './views/screens/posts_details_screen.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/', initial: true),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: MyPostsRoute.page, path: '/my_posts'),
        AutoRoute(page: PostsDetailsRoute.page, path: '/posts_details'),
      ];
}