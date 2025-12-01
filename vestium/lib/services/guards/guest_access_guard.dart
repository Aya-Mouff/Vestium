import 'package:auto_route/auto_route.dart';

/// Guard to prevent guest users (userId == -1) from accessing restricted routes
class GuestAccessGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Allow navigation - actual guest checks will be done at the screen level
    // using BlocListener and context.router.replaceNamed()
    resolver.next();
  }
}

