import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/app_router.dart';
import 'package:vestium/repo/user_repo.dart';
import 'package:vestium/l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;

    return BlocProvider<SignupCubit>(
      create: (context) => _signUpCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        body: BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              final message = loc.signupWelcomeUser(state.user.fullName ?? '');
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              
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
                  Text(
                    loc.signupTitle,
                    style: const TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.signupSubtitle,
                    style: const TextStyle(
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
                              return loc.signupFullNameRequired;
                            }
                            if (value.length < 2) {
                              return loc.signupFullNameTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        EmailField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.signupEmailRequired;
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return loc.signupEmailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        PasswordField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.signupPasswordRequired;
                            }
                            if (value.length < 6) {
                              return loc.signupPasswordTooShort;
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
                                      Colors.grey.withValues(alpha: .5),
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
                                    : Text(
                                        loc.signupButton,
                                        style: const TextStyle(
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
                      Text(
                        loc.signupHaveAccount,
                        style: const TextStyle(
                          fontFamily: 'inter',
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.router.push(const LogInRoute());
                        },
                        child: Text(
                          loc.signupSignIn,
                          style: const TextStyle(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}