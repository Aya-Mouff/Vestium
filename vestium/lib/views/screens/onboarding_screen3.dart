import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE8E3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Icon Container
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4)),
                  ],
                ),
                child: Center(child: Icon(Icons.style_outlined, size: 36, color: const Color(0xFF795548))),
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                'Discover Style',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'CormorantGaramond',
                  color: Color(0xFF3D2F2F),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Get personalized outfit recommendations based on your wardrobe and preferences.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontFamily: 'Inter',
                    color: Color(0xFF6B5B4F),
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              const Spacer(flex: 4),

              // Page Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: const Color(0xFF795548).withOpacity(0.3), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: const Color(0xFF795548).withOpacity(0.3), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 8,
                    decoration: BoxDecoration(color: const Color(0xFF795548), borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Get Started Button (replaces Next button)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    print('Get Started button pressed');
                    // Navigate to home screen or main app
                    // Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3),
                  ),
                ),
              ),

              // Empty space where Skip button would be (to maintain same layout)
              const SizedBox(height: 16),
              const SizedBox(height: 40), // This replaces the Skip button space

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
