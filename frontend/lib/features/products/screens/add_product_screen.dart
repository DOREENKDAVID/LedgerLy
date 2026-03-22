import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';

class AddProductSuccessScreen extends StatelessWidget {
  const AddProductSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              /// Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 70,
                  color: AppColors.primaryTeal,
                ),
              ),

              const SizedBox(height: 40),

              /// Title
              Text(
                "Product Added!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}