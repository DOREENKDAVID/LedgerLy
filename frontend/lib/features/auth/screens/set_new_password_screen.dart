import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/auth/screens/password_reset_success_screen.dart';
import 'package:ledgerly_v3/features/auth/widgets/auth_text_field.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isFormValid = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _newPasswordController.text.length >= 8 &&
          _newPasswordController.text == _confirmPasswordController.text;
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
                      "Set new password",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Create and confirm your new\npassword",
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

              // New Password Field
              AuthTextField(
                controller: _newPasswordController,
                labelText: "New password",
                hintText: "************",
                isPassword: true,
                obscureText: true,
                onChanged: (_) => _validateForm(),
              ),

              const SizedBox(height: 24),

              // Confirm Password Field
              AuthTextField(
                controller: _confirmPasswordController,
                labelText: "Confirm new password",
                hintText: "************",
                isPassword: true,
                obscureText: true,
                onChanged: (_) => _validateForm(),
              ),

              // Error message if passwords don't match
              if (_confirmPasswordController.text.isNotEmpty &&
                  _newPasswordController.text !=
                      _confirmPasswordController.text)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Passwords don't match",
                    style: TextStyle(
                      color: AppColors.errorRed,
                      fontSize: 12,
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // Reset Password Button
              LedgerlyButton(
                label: "Reset password",
                onPressed: _isFormValid
                    ? () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PasswordResetSuccessScreen(),
                          ),
                        )
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
