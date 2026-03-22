import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/features/business/screens/business_success_screen.dart';

enum BusinessType { shop, online, both }

class BusinessIntroScreen extends StatefulWidget {
  const BusinessIntroScreen({super.key});

  @override
  State<BusinessIntroScreen> createState() => _BusinessIntroScreenState();
}

class _BusinessIntroScreenState extends State<BusinessIntroScreen> {
  BusinessType? selectedType;
  String? selectedTypeString;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonHeight = screenWidth * 0.12; // Adjust button height based on screen width
    final buttonWidth = screenWidth * 0.4; // Adjust button width based on screen width

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // 🔹 Progress bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 🔹 Title
              Text(
                'Tell us about your business',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 Subtitle
              Text(
                'This helps LedgerLy give you insights that match your shop type.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(height: 32),

              // 🔹 Options
              _buildOptionCard(
                type: BusinessType.shop,
                title: 'Shop',
                subtitle: 'Physical retail location',
                icon: Icons.storefront_outlined,
              ),

              const SizedBox(height: 16),

              _buildOptionCard(
                type: BusinessType.online,
                title: 'Online Seller',
                subtitle: 'E-commerce or social media',
                icon: Icons.shopping_bag_outlined,
              ),

              const SizedBox(height: 16),

              _buildOptionCard(
                type: BusinessType.both,
                title: 'Both Online & Physical',
                subtitle: 'Multi-channel business',
                icon: Icons.store_mall_directory_outlined,
              ),

              const Spacer(),

              // 🔹 Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textDark,
                        textStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedType != null) {
                          _navigateToBusinessSuccessScreen(context, selectedTypeString!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a business type'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBusinessSuccessScreen(BuildContext context, String businessId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BusinessSuccessScreen(businessId: businessId),
      ),
    );
  }

  // 🔹 Option Card Widget
  Widget _buildOptionCard({
    required BusinessType type,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.primaryTeal),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}