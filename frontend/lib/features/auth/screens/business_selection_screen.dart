import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/auth/screens/setup_success_screen.dart';

class BusinessSelectionScreen extends StatefulWidget {
  const BusinessSelectionScreen({super.key});

  @override
  State<BusinessSelectionScreen> createState() =>
      _BusinessSelectionScreenState();
}

class _BusinessSelectionScreenState extends State<BusinessSelectionScreen> {
  String? _selectedIndustry;

  final List<Map<String, dynamic>> _industries = [
    {"name": "Grocery", "icon": "assets/icons/business-grocery.svg"},
    {"name": "Pharmacy", "icon": "assets/icons/business-pharmacy.svg"},
    {"name": "Fashion", "icon": "assets/icons/business-fashion.svg"},
    {"name": "Electronics", "icon": "assets/icons/business-electronics.svg"},
    {"name": "Restaurant", "icon": "assets/icons/business-restaurant.svg"},
    {"name": "Other", "icon": "assets/icons/business-other.svg"},
  ];

  void _handleSelection() {
    if (_selectedIndustry != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetupSuccessScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customize Your Experience",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Select your business type so Ledgerly can provide industry-specific profit tips.",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _industries.length,
                  itemBuilder: (context, index) {
                    final industry = _industries[index];
                    final bool isSelected =
                        _selectedIndustry == industry['name'];

                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedIndustry = industry['name']),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppColors.primaryTeal : Colors.white,
                          borderRadius: BorderRadius.circular(
                            isSelected ? 20 : 12, // 20px for selected per spec
                          ),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryTeal
                                : AppColors.borderGrey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                isSelected
                                    ? Colors.white
                                    : AppColors.primaryTeal,
                                BlendMode.srcIn,
                              ),
                              child: SvgPicture.asset(
                                industry['icon'],
                                width: 35,
                                height: 35,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              industry['name'],
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              LedgerlyButton(
                label: "Finish Setup",
                onPressed: _selectedIndustry == null ? null : _handleSelection,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
