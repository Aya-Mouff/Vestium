import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/repo/user_repo.dart';
import 'cubit/signup_cubit.dart';
import 'cubit/signup_state.dart';
import 'widgets/email_field.dart';
import 'widgets/full_name_field.dart';
import 'widgets/password_field.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late SignupCubit _signUpCubit;

  @override
  void initState() {
    super.initState();
    _signUpCubit = SignupCubit(UserRepo());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _signUpCubit.close();
    super.dispose();
  }

  void _handleCreateAccount() {
    if (_formKey.currentState!.validate()) {
      _signUpCubit.signUp(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupCubit>(
      create: (context) => _signUpCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        body: BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Welcome ${state.user.fullName}!',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              
              // Navigate to home screen with user ID
              final userId = state.user.userId ?? -1;
              context.router.pushAndPopUntil(
                HomeRoute(userId: userId),
                predicate: (route) => false,
              );
            } else if (state is SignupError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Image.asset(
                    'assets/images/logos/logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Join Vestium and start your style journey',
                    style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: 14,
                      color: Color(0xFF6B5344),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FullNameField(
                          controller: _fullNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            if (value.length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        EmailField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        PasswordField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        BlocBuilder<SignupCubit, SignupState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state is SignupLoading
                                    ? null
                                    : _handleCreateAccount,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6B5344),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  disabledBackgroundColor:
                                      Colors.grey.withOpacity(0.5),
                                ),
                                child: state is SignupLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          fontFamily: 'CormorantGaramond',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.router.push(const LogInRoute());
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B5344),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // DEBUG BUTTON REMOVED - Don't include in production!
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}