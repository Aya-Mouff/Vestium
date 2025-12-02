import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'help_center_state.dart';

class HelpCenterCubit extends Cubit<HelpCenterState> {
  HelpCenterCubit() : super(const HelpCenterInitial());

  void toggleFAQItem(int index) {
    final currentState = state as HelpCenterFAQLoaded;
    final updatedFAQs = List<FAQItem>.from(currentState.faqs);
    updatedFAQs[index] = FAQItem(
      question: updatedFAQs[index].question,
      answer: updatedFAQs[index].answer,
      isExpanded: !updatedFAQs[index].isExpanded,
    );
    emit(HelpCenterFAQLoaded(updatedFAQs));
  }

  void loadFAQs() {
    final faqs = [
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
    emit(HelpCenterFAQLoaded(faqs));
  }
}

class FAQItem {
  final String question;
  final String answer;
  final bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
