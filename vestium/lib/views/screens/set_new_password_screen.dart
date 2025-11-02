import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Password requirement checks
  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordRequirements(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasLowerCase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
    });
  }

  bool _allRequirementsMet() {
    return _hasMinLength && _hasUpperCase && _hasLowerCase && _hasNumber;
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate() &&
        _allRequirementsMet() &&
        _newPasswordController.text == _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully!'),
          backgroundColor: Color(0xFF6B5344),
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        context.router.replaceNamed('/sign-in');
      });
    } else if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5ECE7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () => context.router.maybePop(),
        ),
        title: const Text(
          'Reset Password',
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Lock Icon
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8DFD7),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: Color(0xFFA1887F),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Create New Password',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontStyle: FontStyle.italic,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                'Your new password must be different\nfrom previously used passwords',
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 14,
                  color: Color(0xFF666666),
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
                    // New Password Field
                    const Text(
                      'New Password',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B5344),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      onChanged: _updatePasswordRequirements,
                      cursorColor: const Color(0xFF6B5344),
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                        hintStyle: const TextStyle(
                          fontFamily: 'inter',
                          color: Color(0xFFA1887F),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFFA1887F),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFFA1887F),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0EBE6),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFFD7CCC8),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFFD7CCC8),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'inter',
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Confirm Password Field
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B5344),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      cursorColor: const Color(0xFF6B5344),
                      decoration: InputDecoration(
                        hintText: 'Confirm new password',
                        hintStyle: const TextStyle(
                          fontFamily: 'inter',
                          color: Color(0xFFA1887F),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFFA1887F),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFFA1887F),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0EBE6),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFFD7CCC8),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFFD7CCC8),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'inter',
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Password Requirements
                    const Text(
                      'Password must contain:',
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRequirementItem(
                      'At least 8 characters',
                      _hasMinLength,
                    ),
                    _buildRequirementItem(
                      'One uppercase letter',
                      _hasUpperCase,
                    ),
                    _buildRequirementItem(
                      'One lowercase letter',
                      _hasLowerCase,
                    ),
                    _buildRequirementItem(
                      'One number',
                      _hasNumber,
                    ),
                    const SizedBox(height: 32),
                    // Reset Password Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _allRequirementsMet() &&
                                _newPasswordController.text.isNotEmpty &&
                                _confirmPasswordController.text.isNotEmpty
                            ? _resetPassword
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B5344),
                          disabledBackgroundColor: const Color(0xFFD7CCC8),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Reset Password',
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? const Color(0xFF6B5344) : const Color(0xFFA1887F),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'inter',
              fontSize: 13,
              color: isMet ? const Color(0xFF6B5344) : const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}
