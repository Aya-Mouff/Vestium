part of 'help_center_cubit.dart';

abstract class HelpCenterState extends Equatable {
  const HelpCenterState();

  @override
  List<Object?> get props => [];
}

class HelpCenterInitial extends HelpCenterState {
  const HelpCenterInitial();
}

class HelpCenterFAQLoaded extends HelpCenterState {
  final List<FAQItem> faqs;

  const HelpCenterFAQLoaded(this.faqs);

  @override
  List<Object?> get props => [faqs];
}
