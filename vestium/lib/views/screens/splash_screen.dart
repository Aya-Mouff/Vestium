import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'package:vestium/l10n/app_localizations.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // If logged in -> go directly to home
    if (CurrentUserService.isLoggedIn &&
        CurrentUserService.currentUserId != null) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.router.replace(
            HomeRoute(userId: CurrentUserService.currentUserId!),
          );
        });
      }
    } else {
      // Not logged in -> stay on splash UI
      if (mounted) {
        setState(() {
          _isCheckingAuth = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // While checking auth, show loader
    if (_isCheckingAuth) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/backgrounds/fabric background.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logos/Logo and name.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: Color(0xFF795548),
                ),
                const SizedBox(height: 20),
                Text(
                  loc.splashCheckingAuth,
                  style: const TextStyle(
                    color: Color(0xFFD7CCC8),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Original splash content (not logged in)
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/backgrounds/fabric background.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: .5),
                Colors.black.withValues(alpha: .5),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Logo
                  Image.asset(
                    'assets/images/logos/Logo and name.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 5),
                  // Subtitle
                  Text(
                    loc.splashSubtitle,
                    style: const TextStyle(
                      color: Color(0xFFD7CCC8),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    loc.splashDescription,
                    style: const TextStyle(
                      color: Color(0xFFD7CCC8),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 2),
                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pushRoute(const SignUpRoute());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF795548),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        loc.splashSignUp,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          color: Color(0xFFF5ECE7),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Continue as Guest button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pushRoute(HomeRoute(userId: -1));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x1FD5CCC8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Color(0xFFF5ECE7),
                            width: 0.5,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        loc.splashContinueAsGuest,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          color: Color(0xFFF5ECE7),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Already have an account
                  TextButton(
                    onPressed: () {
                      context.pushRoute(const LogInRoute());
                    },
                    child: Text(
                      loc.splashAlreadyHaveAccount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        decorationColor: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
