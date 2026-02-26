import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/core/widgets/inputs/otp_input_field.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';

enum OtpState {
  normal,
  error,
  expired,
}

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String? password;

  const OtpVerificationScreen({super.key, required this.email, this.password});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  OtpState _otpState = OtpState.normal;

  // Controllers to track input and manually test edge cases (6-digit OTP)
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _c4 = TextEditingController();
  final _c5 = TextEditingController();
  final _c6 = TextEditingController();

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();
    _c5.dispose();
    _c6.dispose();
    super.dispose();
  }

  void _validateOtp() {
    String code = _c1.text + _c2.text + _c3.text + _c4.text + _c5.text + _c6.text;
    if (code.length < 6) {
      setState(() => _otpState = OtpState.normal);
      return;
    }

    // Attempt server verification
    _submitOtp(code);
  }


  @override
  Widget build(BuildContext context) {
    bool hasError = _otpState != OtpState.normal;

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
              const SizedBox(height: 20),

              // 1. Logo
              Center(
                child: Image.asset(
                  'assets/images/logos/favicon_1.png', // The correct logo file
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

              // 2. Title & Subtitle
              Text(
                "Verify your account",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                "We've sent a 6-digit code to\n${widget.email}",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // 3. OTP Inputs (6 digits)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OtpInputField(controller: _c1, first: true, last: false, hasError: hasError, onChanged: (_) => _validateOtp()),
                  OtpInputField(controller: _c2, first: false, last: false, hasError: hasError, onChanged: (_) => _validateOtp()),
                  OtpInputField(controller: _c3, first: false, last: false, hasError: hasError, onChanged: (_) => _validateOtp()),
                  OtpInputField(controller: _c4, first: false, last: false, hasError: hasError, onChanged: (_) => _validateOtp()),
                  OtpInputField(controller: _c5, first: false, last: false, hasError: hasError, onChanged: (_) => _validateOtp()),
                  OtpInputField(controller: _c6, first: false, last: true, hasError: hasError, onChanged: (_) => _validateOtp(), onSubmit: _validateOtp),
                ],
              ),
              const SizedBox(height: 32),

              // 4. Dynamic Feedback String
              Center(child: _buildFeedbackString()),
              
              const SizedBox(height: 40),

              // 5. Continue Button
              LedgerlyButton(
                label: "Continue",
                onPressed: _validateOtp,
              ),
              const SizedBox(height: 24),

              // 6. Back Button
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left, color: AppColors.textDark, size: 24),
                  label: Text(
                    "Back",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitOtp(String code) async {
    // Call backend verify for registration OTP
    try {
      final body = {
        'email': widget.email,
        'enteredOtp': code,
      };
      // Use ApiService to verify
      final res = await ApiService.post('/auth/verify-email-otp', body: body);
      // on success, if password was passed, auto-login and navigate
      if (widget.password != null) {
        await ApiService.login(widget.email, widget.password!);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/business-intro');
      } else {
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _otpState = OtpState.error);
      final message = (e is Exception) ? e.toString().replaceFirst('ApiException: ', '') : 'Verification failed';
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Widget _buildFeedbackString() {
    switch (_otpState) {
      case OtpState.normal:
        return Row(
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
              onTap: () async {
                try {
                  final resp = await ApiService.post('/auth/resend-otp', body: {'email': widget.email});
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['message'] ?? 'OTP resent')));
                } catch (e) {
                  final msg = (e is Exception) ? e.toString().replaceFirst('ApiException: ', '') : 'Resend failed';
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              child: Text(
                "Click to resend",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.primaryTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      case OtpState.error:
        return Text(
          "Incorrect code, please try again",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.errorRed,
            fontWeight: FontWeight.w500,
          ),
        );
      case OtpState.expired:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Expired code, ",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.errorRed,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() => _otpState = OtpState.normal);
              },
              child: Text(
                "Click to request a new one",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.primaryTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
    }
  }
}
