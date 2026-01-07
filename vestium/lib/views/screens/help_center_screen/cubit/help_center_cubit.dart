import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vestium/l10n/app_localizations.dart';

part 'help_center_state.dart';

class HelpCenterCubit extends Cubit<HelpCenterState> {
  final AppLocalizations localizations;

  HelpCenterCubit({required this.localizations}) : super(const HelpCenterInitial());

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
      FAQItem(question: localizations.helpCenterFAQ1Question, answer: localizations.helpCenterFAQ1Answer),
      FAQItem(question: localizations.helpCenterFAQ2Question, answer: localizations.helpCenterFAQ2Answer),
      FAQItem(question: localizations.helpCenterFAQ3Question, answer: localizations.helpCenterFAQ3Answer),
      FAQItem(question: localizations.helpCenterFAQ4Question, answer: localizations.helpCenterFAQ4Answer),
      FAQItem(question: localizations.helpCenterFAQ5Question, answer: localizations.helpCenterFAQ5Answer),
      FAQItem(question: localizations.helpCenterFAQ6Question, answer: localizations.helpCenterFAQ6Answer),
      FAQItem(question: localizations.helpCenterFAQ7Question, answer: localizations.helpCenterFAQ7Answer),
      FAQItem(question: localizations.helpCenterFAQ8Question, answer: localizations.helpCenterFAQ8Answer),
    ];
    emit(HelpCenterFAQLoaded(faqs));
  }
}

class FAQItem {
  final String question;
  final String answer;
  final bool isExpanded;

  FAQItem({required this.question, required this.answer, this.isExpanded = false});
}
