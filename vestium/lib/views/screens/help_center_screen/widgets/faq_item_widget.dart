import 'package:flutter/material.dart';
import '../cubit/help_center_cubit.dart';

class FAQItemWidget extends StatefulWidget {
  final FAQItem faqItem;
  final int index;
  final VoidCallback onTap;

  const FAQItemWidget({
    super.key,
    required this.faqItem,
    required this.index,
    required this.onTap,
  });

  @override
  State<FAQItemWidget> createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<FAQItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    
    if (widget.faqItem.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FAQItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.faqItem.isExpanded != oldWidget.faqItem.isExpanded) {
      if (widget.faqItem.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8DDD5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.faqItem.question,
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  RotationTransition(
                    turns: _animation,
                    child: const Icon(
                      Icons.expand_more,
                      color: Color(0xFFA1887F),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.faqItem.isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE8DDD5),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                widget.faqItem.answer,
                style: const TextStyle(
                  fontFamily: 'inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
