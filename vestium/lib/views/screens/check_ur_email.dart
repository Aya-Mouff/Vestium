import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class CheckEmailScreen extends StatelessWidget {
  final String email;

  const CheckEmailScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 90),
              // Logo
              Image.asset(
                'assets/images/logos/logo.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              // Email Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF0EBE6),
                  border: Border.all(
                    color: const Color(0xFFD7CCC8),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.mail_outline,
                  color: Color(0xFF6B5344),
                  size: 32,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Check Your Email',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  fontSize: 26,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle with email
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'inter',
                    fontSize: 14,
                    color: Color(0xFF6B5344),
                  ),
                  children: [
                    const TextSpan(
                      text: 'We sent a password reset link to ',
                    ),
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            
              const SizedBox(height: 32),
              // Back to Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.router.maybePop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B5344),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back to Sign In',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Resend Link
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reset link resent to your email'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'Didn\'t receive the email? Resend',
                  style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B5344),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionItem({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD7CCC8),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontFamily: 'inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B5344),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'inter',
              fontSize: 13,
              color: Color(0xFF6B5344),
            ),
          ),
        ),
      ],
    );
  }
}
