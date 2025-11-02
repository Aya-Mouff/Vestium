import 'package:flutter/material.dart';
import 'onboarding_screen2.dart';
import 'package:auto_route/auto_route.dart';
import '../../app_router.dart';

@RoutePage()
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
                child: Center(child: Icon(Icons.camera_alt_outlined, size: 36, color: const Color(0xFF795548))),
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                'Capture & Organize',
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
                  'Snap photos of your clothing items and build your digital wardrobe effortlessly.',
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
                    width: 24,
                    height: 8,
                    decoration: BoxDecoration(color: const Color(0xFF795548), borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 8),
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
                ],
              ),

              const SizedBox(height: 32),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    print('Next button pressed');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingScreen2()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Skip Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    print('Skip button pressed');
                    // Add skip navigation logic here
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
