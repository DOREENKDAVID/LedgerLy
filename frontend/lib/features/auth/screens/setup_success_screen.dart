import 'package:flutter/material.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/home/screens/main_screen.dart';

class SetupSuccessScreen extends StatelessWidget {
  const SetupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Green checkmark from Business Profile Setup (1).jpg
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.backgroundGrey,
              child: Icon(Icons.check_circle,
                  size: 80, color: AppColors.successGreen),
            ),
            const SizedBox(height: 30),
            const Text("All set!",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 10),
            const Text("Your business profile is ready.",
                style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 50),
            LedgerlyButton(
              label: "Get Started",
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
