import 'package:flutter/material.dart';

class SelectOutfitAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int currentIndex;
  final VoidCallback onBack;
  final ValueChanged<int> onTabChanged;

  const SelectOutfitAppBar({
    super.key,
    required this.currentIndex,
    required this.onBack,
    required this.onTabChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60 + kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBack,
      ),
      centerTitle: true,
      title: const Text(
        'Select Outfit',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _TabButton(
                  label: 'Saved Outfits',
                  icon: Icons.bookmark_outline,
                  isSelected: currentIndex == 0,
                  onTap: () => onTabChanged(0),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  label: 'Gallery',
                  icon: Icons.photo_library_outlined,
                  isSelected: currentIndex == 1,
                  onTap: () => onTabChanged(1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF5EDE8) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: const Color(0xFF8B6B5C), width: 1)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? const Color(0xFF8B6B5C)
                    : Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? const Color(0xFF8B6B5C)
                      : Colors.grey[700],
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
