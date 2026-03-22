import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';

class ProductsIntroScreen extends StatelessWidget {
  const ProductsIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              /// Title
              Text(
                "Let's Add What You Sell! 🛍️",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101618),
                    ),
              ),

              const SizedBox(height: 40),

              /// Illustration Circle
              Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF088E7C),
                      Color(0xFF022823),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 100,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

              /// Subtitle
              Text(
                "Add your first product to get started.\n"
                "We’ll help you track your profits and margins automatically.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF434C4F),
                      height: 1.5,
                    ),
              ),

              const Spacer(),

              /// Add Product Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/products/add');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add Product'),
              ),

              const SizedBox(height: 16),

              /// Skip Button
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/dashboard');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryTeal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Skip'),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}