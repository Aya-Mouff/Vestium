import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

import './app_router.dart';
import 'databases/db_helper.dart';
import 'databases/services/current_user_service.dart';
import 'repo/user_repo.dart';
import 'repo/outfit_repo.dart';

Future<void> initMyApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await DBHelper.getDatabase();
  
  // Load last user ONLY if they were logged in
  await CurrentUserService.loadLastUserFromDatabase();
}

void main() async {
  await initMyApp();

  final appRouter = AppRouter();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepo>(
          create: (_) => UserRepo(),
        ),
        RepositoryProvider<OutfitRepo>(
          create: (_) => OutfitRepo(),
        ),
      ],
      child: MyApp(appRouter: appRouter),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setInitialRoute();
  }

  void _setInitialRoute() {
    // Set initial route based on login state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (CurrentUserService.isLoggedIn && 
          CurrentUserService.currentUserId != null) {
        // User is logged in, navigate to home
        widget.appRouter.replace(
          HomeRoute(userId: CurrentUserService.currentUserId!),
        );
      } else {
        // User is NOT logged in, navigate to login screen
        widget.appRouter.replace(const LogInRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: widget.appRouter.delegate(),
      routeInformationParser: widget.appRouter.defaultRouteParser(),
      title: 'Vestium',
    );
  }
}