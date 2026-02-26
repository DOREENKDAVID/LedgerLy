import 'package:flutter/material.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/auth/screens/otp_verification_screen.dart';

class SignupBusinessScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const SignupBusinessScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  State<SignupBusinessScreen> createState() => _SignupBusinessScreenState();
}

class _SignupBusinessScreenState extends State<SignupBusinessScreen> {
  String? _selectedIndustry;

  // Business types defined in the Project Brief [cite: 26, 27, 28, 29]
  final List<Map<String, dynamic>> _industries = [
    {"name": "Retail Shop", "icon": Icons.storefront},
    {"name": "Market Trader", "icon": Icons.store},
    {"name": "Online Vendor", "icon": Icons.language},
    {"name": "Micro Retail", "icon": Icons.shopping_bag_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Logo to match your Splash Sequence
              Center(
                  child: Image.asset('assets/images/logo.png',
                      height: 60,
                      errorBuilder: (c, e, s) => Image.asset(
                          'assets/images/favicon_1.png',
                          height: 60))),
              const SizedBox(height: 30),
              const Text("Your Business Type",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal)),
              const SizedBox(height: 10),
              const Text(
                  "This helps LedgerLy customize your profit insights and product performance analysis."), // Per brief [cite: 7, 8]
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
                    bool isSelected = _selectedIndustry == industry['name'];
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedIndustry = industry['name']),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryTeal.withOpacity(0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(
                              20), // Softened stadium-ish corners
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryTeal
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(industry['icon'],
                                size: 40,
                                color: isSelected
                                    ? AppColors.primaryTeal
                                    : Colors.grey),
                            const SizedBox(height: 12),
                            Text(industry['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? AppColors.primaryTeal
                                        : Colors.black87)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              // Final Step of Onboarding [cite: 147]
              LedgerlyButton(
                label: "Complete Setup",
                onPressed: _selectedIndustry != null
                    ? () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const OtpVerificationScreen()))
                    : () {},
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
