import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/core/widgets/inputs/otp_input_field.dart';
import 'package:ledgerly_v3/features/auth/screens/set_new_password_screen.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';

class PasswordResetOTPScreen extends StatefulWidget {
  final String email;

  const PasswordResetOTPScreen({super.key, required this.email});

  @override
  State<PasswordResetOTPScreen> createState() => _PasswordResetOTPScreenState();
}

class _PasswordResetOTPScreenState extends State<PasswordResetOTPScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  late Timer _timer;
  int _start = 60;
  bool _canResend = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  bool _isOtpComplete() {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
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

              // Title & Subtitle
              Text(
                "Password reset",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                "We've sent a 4-digit code to\n${widget.email}",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // OTP Inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OtpInputField(
                    controller: _otpControllers[0],
                    first: true,
                    last: false,
                    hasError: false,
                    onChanged: (_) => setState(() {}),
                  ),
                  OtpInputField(
                    controller: _otpControllers[1],
                    first: false,
                    last: false,
                    hasError: false,
                    onChanged: (_) => setState(() {}),
                  ),
                  OtpInputField(
                    controller: _otpControllers[2],
                    first: false,
                    last: false,
                    hasError: false,
                    onChanged: (_) => setState(() {}),
                  ),
                  OtpInputField(
                    controller: _otpControllers[3],
                    first: false,
                    last: true,
                    hasError: false,
                    onChanged: (_) => setState(() {}),
                    onSubmit: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Resend Text
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive email? ",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: _canResend
                          ? () async {
                              setState(() {
                                _isResending = true;
                                _startTimer();
                              });
                              try {
                                final res = await ApiService.post('/auth/resend-otp', body: {'email': widget.email});
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'OTP resent')));
                              } catch (e) {
                                final msg = e is Exception ? e.toString().replaceFirst('ApiException', '') : 'Failed to resend OTP';
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                              } finally {
                                if (mounted) setState(() { _isResending = false; });
                              }
                            }
                          : null,
                      child: Text(
                        _canResend ? (_isResending ? 'Resending...' : 'Click to resend') : "Resend in 00:${_start.toString().padLeft(2, '0')}",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: _canResend ? AppColors.primaryTeal : AppColors.textGrey,
                          fontWeight: _canResend ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Continue Button
              LedgerlyButton(
                label: "Continue",
                onPressed: _isOtpComplete()
                    ? () async {
                        final entered = _otpControllers.map((c) => c.text).join();
                        try {
                          final res = await ApiService.post('/auth/validate-otp', body: {'email': widget.email, 'enteredOtp': entered});
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'OTP verified')));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SetNewPasswordScreen(),
                            ),
                          );
                        } catch (e) {
                          final msg = e is Exception ? e.toString().replaceFirst('ApiException', '') : 'OTP validation failed';
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
