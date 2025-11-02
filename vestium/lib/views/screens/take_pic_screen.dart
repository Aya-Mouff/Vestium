import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:vestium/app_router.dart';

@RoutePage()
class TakePicScreen extends StatefulWidget {
  const TakePicScreen({super.key});

  @override
  State<TakePicScreen> createState() => _TakePicScreenState();
}

class _TakePicScreenState extends State<TakePicScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _isCameraActive = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint('Error loading cameras: $e');
    }
  }

  Future<void> _startCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;
    
    setState(() => _isLoading = true);
    
    try {
      await _setupCamera(_selectedCameraIndex);
      setState(() => _isCameraActive = true);
    } catch (e) {
      debugPrint('Error starting camera: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    _cameraController = CameraController(
      _cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error setting up camera: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    setState(() => _isLoading = true);
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    await _setupCamera(_selectedCameraIndex);
  }

  Future<void> _capturePhoto() async {
  if (_cameraController == null || !_cameraController!.value.isInitialized) {
    return;
  }

  try {
    final image = await _cameraController!.takePicture();
    if (!mounted) return;
    
    // Navigate to photo preview screen with the captured image
    context.router.push(PhotoPreviewRoute(imagePath: image.path));
  } catch (e) {
    debugPrint('Error capturing photo: $e');
  }
}

  Future<void> _openGallery() async {
    // Implement image picker for gallery
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Gallery picker - Coming soon'),
    //     backgroundColor: Color(0xFF795548),
    //   ),
    // );
    context.router.push(const GalleryAccessRoute());
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SafeArea(
        child: Column(
          children: [
            // Header (white container)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.router.maybePop();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF3E2723),
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Add Item',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3E2723),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            // Camera Preview Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                // Remove padding when camera is active, keep it for placeholder
                padding: _isCameraActive ? EdgeInsets.zero : const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFD7CCC8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF795548),
                        ),
                      )
                    : _isCameraActive && _isInitialized && _cameraController != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Camera preview fills the entire container
                                SizedBox.expand(
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _cameraController!.value.previewSize!.height,
                                      height: _cameraController!.value.previewSize!.width,
                                      child: CameraPreview(_cameraController!),
                                    ),
                                  ),
                                ),
                                // Close button to go back to placeholder
                                Positioned(
                                  top: 16,
                                  left: 16,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isCameraActive = false;
                                        _isInitialized = false;
                                        _cameraController?.dispose();
                                        _cameraController = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            // This is the small inner container with placeholder
                            child: GestureDetector(
                              onTap: _startCamera,
                              child: Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(maxWidth: 320),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD7CCC8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF795548).withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: AspectRatio(
                                    aspectRatio: 3 / 4,
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt_outlined,
                                            size: 64,
                                            color: const Color(0xFF795548).withValues(alpha: 0.6),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Position your clothing item',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF795548),
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tap here to start taking picture',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xFF795548).withValues(alpha: 0.6),
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
              ),
            ),
            // Bottom Controls
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery Button
                  GestureDetector(
                    onTap: _openGallery,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD7CCC8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_library_outlined,
                        color: Color(0xFF795548),
                        size: 24,
                      ),
                    ),
                  ),
                  // Capture Button
                  GestureDetector(
                    onTap: _isInitialized ? _capturePhoto : null,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFFFFF),
                        border: Border.all(
                          color: const Color(0xFF795548),
                          width: 8,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF795548),
                        ),
                      ),
                    ),
                  ),
                  // Rotate Button
                  GestureDetector(
                    onTap: _isInitialized ? _flipCamera : null,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD7CCC8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flip_camera_ios_outlined,
                        color: Color(0xFF795548),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}