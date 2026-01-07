import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:firebase_core/firebase_core.dart'; // ADD THIS import

import './app_router.dart';
import 'databases/db_helper.dart';
import 'databases/services/current_user_service.dart';
import 'repo/user_repo.dart';
import 'repo/outfit_repo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

/// Initializes the app before running
/// - Sets up Firebase for Android/iOS
/// - Sets up database for Windows/Linux
/// - Creates database tables
/// - Loads last logged-in user (if any)
Future<void> initMyApp() async {
  // Ensures Flutter bindings are initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for mobile platforms (Android/iOS)
  // Skip Firebase on Windows/Linux since it's not fully supported
  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp();
  }

  // Initialize SQLite FFI for desktop platforms (Windows/Linux)
  // Mobile platforms (Android/iOS) use native SQLite
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Create/open the database and create all tables if first time
  await DBHelper.getDatabase();

  // Check if a user was previously logged in and load their data
  // This allows auto-login when reopening the app
  await CurrentUserService.loadLastUserFromDatabase();
}

/// Entry point of the application
void main() async {
  // Run initialization before starting the app
  await initMyApp();

  // Create the app router for navigation management
  final appRouter = AppRouter();

  // Start the Flutter app
  runApp(
    // Provide repositories to the entire app using BLoC pattern
    // This makes UserRepo and OutfitRepo accessible throughout the widget tree
    MultiRepositoryProvider(
      providers: [
        // Repository for user-related database operations
        RepositoryProvider<UserRepo>(create: (_) => UserRepo()),
        // Repository for outfit-related database operations
        RepositoryProvider<OutfitRepo>(create: (_) => OutfitRepo()),
      ],
      child: MyApp(appRouter: appRouter),
    ),
  );
}

/// Root widget of the application
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
    // Set up initial navigation after widget is built
    _setInitialRoute();
  }

  /// Determines which screen to show when app starts
  /// - If user is logged in → Navigate to Home
  /// - If user is NOT logged in → Navigate to Splash/Login
  void _setInitialRoute() {
    // Wait for the widget tree to be built before navigating
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if user is logged in (from previous session)
      if (CurrentUserService.isLoggedIn && CurrentUserService.currentUserId != null) {
        // User is logged in, navigate to home screen
        widget.appRouter.replace(HomeRoute(userId: CurrentUserService.currentUserId!));
      } else {
        // User is NOT logged in, navigate to splash/login screen
        widget.appRouter.replace(const SplashRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Hide the debug banner in top-right corner
      debugShowCheckedModeBanner: false,

      // Router configuration for navigation
      routerDelegate: widget.appRouter.delegate(),
      routeInformationParser: widget.appRouter.defaultRouteParser(),

      // App title (shown in task manager/app switcher)
      title: 'Vestium',

      // Localization delegates for internationalization (i18n)
      // These provide translations and formatting for different languages
      localizationsDelegates: const [
        AppLocalizations.delegate, // Custom app translations
        GlobalMaterialLocalizations.delegate, // Material widgets translations
        GlobalWidgetsLocalizations.delegate, // Flutter widgets translations
        GlobalCupertinoLocalizations.delegate, // iOS-style widgets translations
      ],

      // Languages supported by the app
      // The app can be displayed in: English, French, Arabic, Italian
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
        Locale('ar'), // Arabic
        Locale('it'), // Italian
      ],

      // Automatically use phone's language with English as fallback
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        // If device locale is null, default to English
        if (deviceLocale == null) {
          return const Locale('en');
        }

        // Check if device language is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == deviceLocale.languageCode) {
            return supportedLocale; // Use device language
          }
        }

        // If device language not supported, default to English
        return const Locale('en');
      },
    );
  }
}
