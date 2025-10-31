import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SingleChildScrollView(
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
              // Title
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
              // Subtitle
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
              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Field
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B5344),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                        controller: _fullNameController,
                        cursorColor: Color(0xFF6B5344), // or any color you want
                        decoration: InputDecoration(
                           hintText: 'Your name',
                           hintStyle: const TextStyle(
                               fontFamily: 'inter',
                               color: Color(0xFFA1887F),
                              ),
                           prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Color(0xFFA1887F),
                            ),
                           filled: true,
                           fillColor: const Color(0xFFF0EBE6),
    
                            // Enabled (unfocused) border
                           enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD7CCC8),
                                  width: 2,
                               ),
                         ),
    
                            // Focused border - THIS REMOVES THE BLUE LINE
                            focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(20),
                               borderSide: const BorderSide(
                                   color: Color(0xFFD7CCC8), // Keep same or use a highlight color
                                   width: 2,
                                  ),
                                ),
    
                       contentPadding: const EdgeInsets.symmetric(
                           horizontal: 16,
                           vertical: 14,
                        ),
                      ),
                       validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                         }
                       return null;
                         },
                     ),
                    const SizedBox(height: 20),
                    // Email Field
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B5344),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Color(0xFF6B5344), 
                      decoration: InputDecoration(
                        hintText: 'you@example.com',
                        hintStyle: TextStyle(
                            fontFamily: 'inter',
                            color: Color(0xFFA1887F), // Change hint text color
                       ),
                        prefixIcon: const Icon(
                          Icons.email_outlined , 
                          color: Color(0xFFA1887F),
                          ),
                        filled: true,
                        fillColor: const Color(0xFFF0EBE6),
                                                    // Enabled (unfocused) border
                           enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD7CCC8),
                                  width: 2,
                               ),
                         ),
    
                            // Focused border - THIS REMOVES THE BLUE LINE
                            focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(20),
                               borderSide: const BorderSide(
                                   color: Color(0xFFD7CCC8), // Keep same or use a highlight color
                                   width: 2,
                                  ),
                                ),
                        
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B5344),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      cursorColor: Color(0xFF6B5344), 
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: TextStyle(
                            color: Color(0xFFA1887F), // Change hint text color
                       ),
                        prefixIcon: const Icon(Icons.lock_outline,
                        color: Color(0xFFA1887F),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0EBE6),
                                                    // Enabled (unfocused) border
                           enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD7CCC8),
                                  width: 2,
                               ),
                         ),
    
                            // Focused border - THIS REMOVES THE BLUE LINE
                            focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(20),
                               borderSide: const BorderSide(
                                   color: Color(0xFFD7CCC8), // Keep same or use a highlight color
                                   width: 2,
                                  ),
                                ),
                      
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
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
                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Color(0xFF6B5344),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Sign In Link
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
                      context.pushRoute(LogInRoute());
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
            ],
          ),
        ),
      ),
    );
  }
}