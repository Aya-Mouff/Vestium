import 'package:flutter/material.dart';

class OutfitPicker extends StatelessWidget {
  final Map<String, dynamic>? selectedOutfit;
  final VoidCallback onSelectOutfit;

  const OutfitPicker({
    super.key,
    required this.selectedOutfit,
    required this.onSelectOutfit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onSelectOutfit,
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
                              errorBuilder: (context, error, stackTrace) {
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
                          onPressed: onSelectOutfit,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
