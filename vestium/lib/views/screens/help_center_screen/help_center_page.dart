import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/help_center_cubit.dart';
import 'widgets/faq_item_widget.dart';

@RoutePage()
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HelpCenterCubit()..loadFAQs(),
      child: const _HelpCenterPage(),
    );
  }
}

class _HelpCenterPage extends StatelessWidget {
  const _HelpCenterPage();

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
              BlocBuilder<HelpCenterCubit, HelpCenterState>(
                builder: (context, state) {
                  if (state is HelpCenterFAQLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.faqs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: FAQItemWidget(
                            faqItem: state.faqs[index],
                            index: index,
                            onTap: () {
                              context.read<HelpCenterCubit>().toggleFAQItem(index);
                            },
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
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
