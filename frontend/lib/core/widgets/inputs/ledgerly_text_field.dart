import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Standard text input field following LedgerLy design system
///
/// Features:
/// - Design system colors and typography
/// - Label support (12px medium grey)
/// - Hint text support (disabledGrey)
/// - Focus state with 2px border
/// - Error state styling
/// - Suffix icon support
class LedgerlyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  const LedgerlyTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.textInputAction,
  });

  @override
  State<LedgerlyTextField> createState() => _LedgerlyTextFieldState();
}

class _LedgerlyTextFieldState extends State<LedgerlyTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textGrey,
        ),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.disabledGrey,
        ),
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryTeal,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.errorRed,
            width: 2,
          ),
        ),
        errorText: widget.errorText,
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.errorRed,
        ),
      ),
    );
  }
}
