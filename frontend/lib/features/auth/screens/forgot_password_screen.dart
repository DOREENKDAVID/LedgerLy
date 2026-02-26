import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/auth/screens/password_reset_otp_screen.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';
import 'package:ledgerly_v3/features/auth/widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isFormValid = emailRegex.hasMatch(_emailController.text);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

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

              // Heading
              Center(
                child: Column(
                  children: [
                    Text(
                      "Forgot password?",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Enter your email and we'll send a\none-time password reset code",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textGrey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Email Input
              AuthTextField(
                controller: _emailController,
                labelText: "Email",
                hintText: "example@example.com",
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _validateForm(),
              ),

              const SizedBox(height: 32),

              // Send Code Button
              LedgerlyButton(
                label: "Continue",
                isLoading: _isLoading,
                onPressed: _isFormValid
                    ? () async {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          final res = await ApiService.post('/auth/forgot-password', body: {'email': _emailController.text.trim()});
                          // show success message and navigate
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'OTP sent')));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordResetOTPScreen(email: _emailController.text.trim()),
                            ),
                          );
                        } catch (e) {
                          final msg = e is Exception ? e.toString().replaceFirst('ApiException', '') : 'Failed to send OTP';
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                        } finally {
                          if (mounted) setState(() { _isLoading = false; });
                        }
                      }
                    : null,
              ),

              const SizedBox(height: 24),

              // Back Button
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.textDark),
                  label: Text(
                    "Back",
                    style: GoogleFonts.inter(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
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
