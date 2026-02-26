import 'package:flutter/material.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/auth/screens/setup_success_screen.dart';

class SignupBusinessDetailsScreen extends StatefulWidget {
  final String category; // Passed from the previous category screen

  const SignupBusinessDetailsScreen({super.key, required this.category});

  @override
  State<SignupBusinessDetailsScreen> createState() =>
      _SignupBusinessDetailsScreenState();
}

class _SignupBusinessDetailsScreenState
    extends State<SignupBusinessDetailsScreen> {
  final _nameController = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What is your business name?",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal)),
            const SizedBox(height: 10),
            const Text("This helps us personalize your dashboard."),
            const SizedBox(height: 30),

            // Your Name Input Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter business name",
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                // Stadium border from Input fiels.png asset
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const Spacer(),

            LedgerlyButton(
              label: "Continue",
              onPressed: () {
                // Navigate to the success screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SetupSuccessScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
