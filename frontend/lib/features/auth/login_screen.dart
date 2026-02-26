import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/auth/screens/forgot_password_screen.dart';
import 'package:ledgerly_v3/features/auth/screens/sign_up_screen.dart';
import 'package:ledgerly_v3/features/auth/widgets/auth_text_field.dart';
import 'package:ledgerly_v3/features/home/screens/main_screen.dart';
import 'package:ledgerly_v3/core/services/analytics_service.dart';
import 'package:provider/provider.dart';
import 'package:ledgerly_v3/core/providers/auth_provider.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';
import 'package:ledgerly_v3/core/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _obscurePassword = true;
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Analytics.instance.logEvent('screen_view', {'screen': 'login'});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isFormValid = emailRegex.hasMatch(_emailController.text) &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await auth.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      // If backend returned a token, navigate. If backend indicates firstTime, navigate to business intro.
      final hasToken = result['token'] != null;
      final firstTime = (result['firstTime'] == true || result['first_time'] == true);

     if (hasToken) {
        if (firstTime) {
          Navigator.pushReplacementNamed(context, '/business-intro');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login succeeded but no token returned')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final message = (e is Exception) ? e.toString().replaceFirst('ApiException: ', '') : 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logos/favicon_1.png',
                  height: 80,
                  width: 80,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.book_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              Text(
                "See how your business is\ndoing today.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 40),

              // Email Field
              AuthTextField(
                controller: _emailController,
                labelText: "Email",
                hintText: "your@email.com",
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _validateForm(),
              ),

              const SizedBox(height: 20),

              // Password Field
              AuthTextField(
                controller: _passwordController,
                labelText: "Password",
                hintText: "••••••••",
                isPassword: true,
                obscureText: true,
                onChanged: (_) => _validateForm(),
              ),

              const SizedBox(height: 30),

              // Login Button
              LedgerlyButton(
                label: "Login",
                isLoading: _isLoading,
                onPressed: _isFormValid && !_isLoading ? _handleLogin : null,
              ),

              const SizedBox(height: 20),

              // Forgot Password Link
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: Text(
                    "Forgot password?",
                    style: GoogleFonts.inter(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.borderGrey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Or continue with",
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.borderGrey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Social Login Options
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.borderGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(
                        Icons.g_translate,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.borderGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(
                        Icons.apple,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Sign Up Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.inter(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      ),
                      child: Text(
                        "Register",
                        style: GoogleFonts.inter(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
