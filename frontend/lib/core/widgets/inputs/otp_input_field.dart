import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// OTP input field for verification codes
///
/// Features:
/// - Auto-focus management between fields
/// - Numeric keyboard only
/// - Design system colors (borderGrey, primaryTeal focus)
/// - Stadium-shaped border radius
class OtpInputField extends StatefulWidget {
  final TextEditingController? controller;
  final bool first;
  final bool last;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmit;

  const OtpInputField({
    super.key,
    this.controller,
    required this.first,
    required this.last,
    this.hasError = false,
    this.onChanged,
    this.onSubmit,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget.first) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        autofocus: widget.first,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.hasError ? AppColors.errorRed : AppColors.borderGrey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.hasError ? AppColors.errorRed : AppColors.borderGrey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.hasError ? AppColors.errorRed : AppColors.primaryTeal,
              width: 2,
            ),
          ),
        ),
        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        onChanged: (value) {
          widget.onChanged?.call(value);

          if (value.isNotEmpty && !widget.last) {
            // Move to next field
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && !widget.first) {
            // Move to previous field
            FocusScope.of(context).previousFocus();
          }

          // If last field and filled, notify submit
          if (widget.last && value.isNotEmpty) {
            widget.onSubmit?.call();
          }
        },
      ),
    );
  }
}
