import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';

@RoutePage()
class CheckEmailScreen extends StatelessWidget {
  final String email;

  const CheckEmailScreen({Key? key, required this.email}) : super(key: key);

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

              const SizedBox(height: 120),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8DDD8),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF8B6F47),
                  size: 48,
                ),
              ),
              const SizedBox(height: 40),

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
                    const TextSpan(text: 'We sent a password reset link to '),
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

              GestureDetector(
                onTap: () {
                  context.pushRoute(ResetPasswordRoute());
                },
                child: const Text(
                  'Try Another Email',
                  style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B5344),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushRoute(LogInRoute());
                   // context.pushRoute(SetNewPasswordRoute());

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B5344),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
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

  const _InstructionItem({required this.number, required this.text});

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
