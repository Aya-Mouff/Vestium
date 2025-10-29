import 'package:flutter/material.dart';
import './app_router.dart';

void main() {
  final _appRouter = AppRouter();
  runApp(MyApp(appRouter: _appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
      title: 'Vestium',
    );
  }
}
