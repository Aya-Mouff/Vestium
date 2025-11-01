import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../app_router.dart';

@RoutePage()
class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  bool isPublic = true;
  Map<String, dynamic>? selectedOutfit;

  @override
  void dispose() {
    _captionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _selectOutfit() async {
    // Navigate to SelectOutfitScreen and wait for result
    final result = await context.router.push(const SelectOutfitRoute());
    
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedOutfit = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'New Post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle post action
                if (selectedOutfit != null) {
                  // You can now use selectedOutfit data
                  print('Posting outfit: ${selectedOutfit!['name']}');
                  print('Caption: ${_captionController.text}');
                  print('Tags: ${_tagsController.text}');
                  print('Public: $isPublic');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B6B5C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Choose an Outfit Container
              Center(
                child: GestureDetector(
                  onTap: _selectOutfit,
                  child: Container(
                    width: 380,
                    height: 344,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: selectedOutfit == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Choose an Outfit',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[400],
                                  fontFamily: 'CormorantGaramond',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: selectedOutfit!['imageUrl'] != null
                                    ? Image.asset(
                                        selectedOutfit!['imageUrl'],
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 60,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Icon(
                                            Icons.checkroom,
                                            size: 60,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                              ),
                              // Overlay with outfit name
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        Colors.transparent,
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    selectedOutfit!['name'] ?? 'Untitled',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'CormorantGaramond',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              // Change outfit button
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Color(0xFF8B6B5C),
                                    ),
                                    onPressed: _selectOutfit,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Caption TextField
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EDE8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _captionController,
                  maxLines: 3,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write a caption for your outfit...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tags Section
              const Text(
                'Tags',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EDE8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _tagsController,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add tags (separated by commas)',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'e.g. casual, summer, ootd',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 16),

              // Quick Tags
              const Text(
                'Quick Tags',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildQuickTag('#ootd'),
                  _buildQuickTag('#casual'),
                  _buildQuickTag('#summer'),
                  _buildQuickTag('#style'),
                  _buildQuickTag('#fashion'),
                ],
              ),
              const SizedBox(height: 20),

              // Public Post Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.public,
                      size: 20,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Public Post',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Your post will be visible to all Vestium users',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Inter',
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isPublic,
                      onChanged: (value) {
                        setState(() {
                          isPublic = value;
                        });
                      },
                      activeColor: const Color(0xFF8B6B5C),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTag(String tag) {
    return InkWell(
      onTap: () {
        // Add tag to tags field
        if (_tagsController.text.isEmpty) {
          _tagsController.text = tag;
        } else {
          _tagsController.text += ', $tag';
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'Inter',
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
