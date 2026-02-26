import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Reusable card component following LedgerLy design system
///
/// Features:
/// - Design system colors (white background, grey border)
/// - Subtle shadow
/// - Customizable padding and border radius
/// - Optional outline/selection state
class LedgerlyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final bool isSelected;
  final VoidCallback? onTap;

  const LedgerlyCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderColor,
    this.borderRadius = 12.0,
    this.borderWidth = 1.0,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : Colors.white,
          borderRadius: BorderRadius.circular(
            isSelected ? 20.0 : borderRadius,
          ),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryTeal
                : (borderColor ?? AppColors.borderGrey),
            width: isSelected ? 2.0 : borderWidth,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryTeal.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: child,
      ),
    );
  }
}
