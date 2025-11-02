import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class CameraAccessScreen extends StatelessWidget {
  const CameraAccessScreen({super.key});

  Future<void> _requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;
    
    if (status.isDenied) {
      // Request permission directly without custom dialog
      final result = await Permission.camera.request();
      
      // Check if widget is still mounted before using context
      if (!context.mounted) return;
      
      if (result.isGranted) {
        // Permission granted - navigate to TakePicScreen
        _navigateToTakePicScreen(context);
      } else if (result.isPermanentlyDenied) {
        // Permission permanently denied - open settings
        await openAppSettings();
      } else {
        // Permission denied but not permanently
        _showPermissionDeniedSnackBar(context);
      }
    } else if (status.isPermanentlyDenied) {
      // Already permanently denied - open settings directly
      await openAppSettings();
    } else if (status.isGranted) {
      // Already granted - navigate to TakePicScreen
      if (!context.mounted) return;
      _navigateToTakePicScreen(context);
    }
  }

  void _navigateToTakePicScreen(BuildContext context) {
    // Navigate to TakePicScreen immediately
    context.router.push(const TakePicRoute());
  }

  void _showPermissionDeniedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera access is required to capture photos.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handleMaybeLater(BuildContext context) {
    // Just pop back or navigate to main app
    context.router.maybePop();
    // or context.router.push(const MainAppRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Camera Icon Circle
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF795548).withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 56,
                    color: const Color(0xFF795548),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Title
              const Text(
                'Camera Access',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3E2723),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              // Description
              const Text(
                'Vestium needs access to your camera to capture photos of your clothing items and add them to your virtual wardrobe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  color: Color(0xFF795548),
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 32),
              // Privacy Notice Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF795548).withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: const Color(0xFF795548).withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Your photos are private',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3E2723),
                              letterSpacing: 0.1,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'We only use your camera to capture clothing items. Your photos stay on your device.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w200,
                              color: Color(0xFF795548),
                              height: 1.5,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              // Allow Camera Access Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF795548),
                      const Color(0xFF795548).withValues(alpha: 0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF795548).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _requestCameraPermission(context),
                    borderRadius: BorderRadius.circular(12),
                    child: const Center(
                      child: Text(
                        'Allow Camera Access',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFFFFF),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Maybe Later Button
              TextButton(
                onPressed: () => _handleMaybeLater(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF795548),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}