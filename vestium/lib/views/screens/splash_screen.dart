import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'login_screen.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.5),
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

                  // Logo and Title
                  Image.asset(
                    'assets/images/logos/Logo and name.png',
                    width: 200,
                    height: 200,
                  ),

                  const SizedBox(height: 5),

                  // Subtitle
                  const Text(
                    'Your personal virtual wardrobe.',
                    style: TextStyle(
                      color: Color(0xFFD7CCC8),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Organize your style, create outfits, and\nshare your fashion journey.',
                    style: TextStyle(
                      color: Color(0xFFD7CCC8),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 2),

                  // Sign Up Button
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
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
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

                  // Continue as Guest Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        context.router.pushNamed('/home');
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
                      child: const Text(
                        'Continue as Guest',
                        style: TextStyle(
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
                      context.pushRoute(LogInRoute());
                    },
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(
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
