import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
@RoutePage()
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'How do I add items to my wardrobe?',
      answer:
          'You can add items to your wardrobe by tapping the camera icon in the wardrobe tab. Take a photo of your clothing item. Then in details like category, color, and season.',
    ),
    FAQItem(
      question: 'How do I create an outfit?',
      answer:
          'To create an outfit, navigate to the Outfits section and tap the "Create New" button. Select items from your wardrobe and arrange them to create your desired outfit combination.',
    ),
    FAQItem(
      question: 'Can I edit or delete wardrobe items?',
      answer:
          'Yes, you can edit or delete wardrobe items by tapping on the item in your wardrobe. Select the edit option to modify details or the delete option to remove the item.',
    ),
    FAQItem(
      question: 'How do I share my outfits?',
      answer:
          'To share your outfits, open the outfit you want to share and tap the share button. You can share via email, social media, or generate a link to share with others.',
    ),
    FAQItem(
      question: 'How do I manage my categories?',
      answer:
          'You can manage your categories in the Settings section under Wardrobe Categories. Add, edit, or delete categories to organize your items the way you prefer.',
    ),
    FAQItem(
      question: 'Can I make my profile private?',
      answer:
          'Yes, you can make your profile private in the Account Settings. Toggle the "Private Profile" option to control who can see your wardrobe and outfits.',
    ),
    FAQItem(
      question: 'How do I reset my password?',
      answer:
          'Go to the Account Settings and select "Change Password". You can also use the "Forgot Password" option on the login screen to reset via email.',
    ),
    FAQItem(
      question: 'How do I delete my account?',
      answer:
          'To delete your account, go to Account Settings and scroll to the "Danger Zone" section. Select "Delete Account" and follow the confirmation steps. This action is permanent.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C2C2C),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Email Us Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF0EBE6),
                      ),
                      child: const Icon(
                        Icons.mail_outline,
                        color: Color(0xFFA1887F),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Email Us',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // FAQ Section Title
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // FAQ Items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: faqItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: FAQItemWidget(
                      faqItem: faqItems[index],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

class FAQItemWidget extends StatefulWidget {
  final FAQItem faqItem;

  const FAQItemWidget({
    super.key,
    required this.faqItem,
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      widget.faqItem.isExpanded = !widget.faqItem.isExpanded;
    });

    if (widget.faqItem.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
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
            onTap: _toggleExpanded,
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
