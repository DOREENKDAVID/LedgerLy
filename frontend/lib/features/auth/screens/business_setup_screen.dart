// lib/features/auth/screens/business_setup_screen.dart
import 'package:flutter/material.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';

class BusinessSetupScreen extends StatefulWidget {
  const BusinessSetupScreen({super.key});

  @override
  State<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends State<BusinessSetupScreen> {
  String? _selectedCategory;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Store", "icon": Icons.storefront},
    {"name": "Online Vendor", "icon": Icons.language},
    {"name": "Market Trader", "icon": Icons.shopping_bag_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const Text("What best describes your business?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            // Selection list matching Business Profile Setup (1).jpg
            ..._categories.map((cat) => _buildCategoryCard(cat)),
            const Spacer(),
            LedgerlyButton(
              label: "Continue",
              onPressed: _selectedCategory != null
                  ? () => _navigateToNameScreen()
                  : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> cat) {
    bool isSelected = _selectedCategory == cat['name'];
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat['name']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.primaryTeal : Colors.grey.shade300,
              width: 2),
          color: isSelected
              ? AppColors.primaryTeal.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(cat['icon'],
                color: isSelected ? AppColors.primaryTeal : Colors.grey),
            const SizedBox(width: 20),
            Text(cat['name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _navigateToNameScreen() {
    // Navigate to the next screen in the business setup flow
  }
}
