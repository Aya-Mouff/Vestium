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
