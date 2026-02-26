import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/auth/screens/otp_verification_screen.dart';
import 'package:ledgerly_v3/features/auth/widgets/auth_text_field.dart';
import 'package:ledgerly_v3/features/auth/screens/forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:ledgerly_v3/core/services/analytics_service.dart';
import 'package:ledgerly_v3/core/providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoginSelected = false; // Toggle between Login/Register
  bool _isEmailError = false; // Used to simulate the "Account already exists" edge case

  @override
  void initState() {
    super.initState();
    Analytics.instance.logEvent('screen_view', {'screen': 'signup'});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _simulateEmailError() {
    // For testing the edge case UI from the screenshot
    setState(() {
      _isEmailError = _emailController.text == "thatdesignergirl@outlook.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo and Welcome Text
              Center(
                child: Image.asset(
                  'assets/images/logos/favicon_1.png', // The correct logo file provided
                  height: 80,
                  width: 80,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.bar_chart, color: Colors.white, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welcome to LedgerLy!",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("🎉", style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Center(
                child: Text(
                  "Let's create your account and get started",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 2. Segmented Control Toggle (Login / Register)
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Light grey background
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isLoginSelected = true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isLoginSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: _isLoginSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Login",
                            style: GoogleFonts.inter(
                              color: _isLoginSelected ? AppColors.textDark : AppColors.textGrey,
                              fontWeight: _isLoginSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isLoginSelected = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_isLoginSelected ? AppColors.primaryTeal : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Register",
                            style: GoogleFonts.inter(
                              color: !_isLoginSelected ? Colors.white : AppColors.textGrey,
                              fontWeight: !_isLoginSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 3. Form Fields using standard new AuthTextField
              AuthTextField(
                controller: _emailController,
                labelText: "Email",
                hintText: "johndoe@example.com",
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _simulateEmailError(), // check for edge case
                hasError: _isEmailError,
                errorText: "Account already exists, Login instead",
              ),
              const SizedBox(height: 20),

              AuthTextField(
                controller: _passwordController,
                labelText: "Password",
                hintText: "************",
                isPassword: true,
                obscureText: true,
              ),
              const SizedBox(height: 20),

              if (!_isLoginSelected) ...[
                AuthTextField(
                  controller: _confirmPasswordController,
                  labelText: "Confirm Password",
                  hintText: "************",
                  isPassword: true,
                  obscureText: true,
                ),
                const SizedBox(height: 32),
              ] else ...[
                 Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    ),
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 4. Action Button
              LedgerlyButton(
                label: _isLoginSelected ? "Login" : "Sign UP",
                onPressed: () async {
                  Analytics.instance.logEvent('signup_action', {'mode': _isLoginSelected ? 'login' : 'register'});
                  final auth = Provider.of<AuthProvider>(context, listen: false);
                  if (_isLoginSelected) {
                    try {
                      await auth.login(_emailController.text.trim(), _passwordController.text.trim());
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    } catch (e) {
                      final msg = (e is Exception) ? e.toString().replaceFirst('ApiException: ', '') : 'Login failed';
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                    }
                  } else {
                    // Register flow: call register then navigate to OTP verification screen
                    try {
                      final res = await auth.register(_emailController.text.trim(), _passwordController.text.trim());
                      if (!mounted) return;
                      // Navigate to OTP verification screen and pass the email
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpVerificationScreen(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        )),
                      );
                    } catch (e) {
                      final msg = (e is Exception) ? e.toString().replaceFirst('ApiException: ', '') : 'Registration failed';
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                    }
                  }
                },
              ),
              const SizedBox(height: 32),

              // 5. Social Logins Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Or continue with",
                      style: GoogleFonts.inter(
                        color: AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                ],
              ),
              const SizedBox(height: 24),

              // 6. Social Providers
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/logos/google.png',
                        height: 20,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.g_mobiledata, color: Colors.red, size: 24),
                      ),
                      label: Text(
                        "Google",
                        style: GoogleFonts.inter(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.apple, color: Colors.black, size: 24),
                      label: Text(
                        "Apple",
                        style: GoogleFonts.inter(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 7. Footer text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLoginSelected ? "Don't have an account? " : "Already have an account? ",
                    style: GoogleFonts.inter(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _isLoginSelected = !_isLoginSelected);
                    },
                    child: Text(
                      _isLoginSelected ? "Register" : "Log in",
                      style: GoogleFonts.inter(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
