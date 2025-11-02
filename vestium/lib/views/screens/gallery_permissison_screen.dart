import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class GalleryAccessScreen extends StatefulWidget {
  const GalleryAccessScreen({super.key});

  @override
  State<GalleryAccessScreen> createState() => _GalleryAccessScreenState();
}

class _GalleryAccessScreenState extends State<GalleryAccessScreen> {
  bool _isRequesting = false;

  Future<void> _allowGalleryAccess() async {
    setState(() => _isRequesting = true);

    try {
      PermissionStatus status = await Permission.photos.status;

      if (status.isDenied) {
        status = await Permission.photos.request();
      }

      if (status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gallery access granted'),
            backgroundColor: Color(0xFF795548),
          ),
        );
        context.router.maybePop(true);
      } else if (status.isPermanentlyDenied) {
        if (!mounted) return;
        _showSettingsDialog();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gallery access denied'),
            backgroundColor: Color(0xFF795548),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error requesting gallery permission: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to request gallery access'),
          backgroundColor: Color(0xFF795548),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isRequesting = false);
      }
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Permission Required',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E2723),
          ),
        ),
        content: const Text(
          'Gallery access has been permanently denied. Please enable it in app settings.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            color: Color(0xFF795548),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: Color(0xFF795548),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF795548),
              foregroundColor: const Color(0xFFFFFFFF),
              elevation: 0,
            ),
            child: const Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _maybeLater() {
    context.router.maybePop(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Icon Container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF795548).withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: const Color(0xFF3E2723),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Title
              const Text(
                'Gallery Access',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3E2723),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 20),
              // Description
              const Text(
                'Vestium needs access to your gallery to pic pictures of your clothing items and add them to your virtual wardrobe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF795548),
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 32),
              // Privacy Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF795548).withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
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
                        children: [
                          const Text(
                            'Your pictures are private',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3E2723),
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'We only use your camera to capture clothing items. Your photos stay on your device.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF795548).withValues(alpha: 0.8),
                              height: 1.4,
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
              // Allow Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isRequesting ? null : _allowGalleryAccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
                    foregroundColor: const Color(0xFFFFFFFF),
                    disabledBackgroundColor: const Color(0xFF795548).withValues(alpha: 0.5),
                    disabledForegroundColor: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isRequesting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFFFFFF),
                          ),
                        )
                      : const Text(
                          'Allow Gallery Access',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              // Maybe Later Button
              TextButton(
                onPressed: _isRequesting ? null : _maybeLater,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF795548),
                  disabledForegroundColor: const Color(0xFF795548).withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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