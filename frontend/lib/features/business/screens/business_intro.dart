import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/features/business/screens/business_screen.dart';


class BusinessIntroScreen extends StatefulWidget {
  const BusinessIntroScreen({super.key});

  @override
  State<BusinessIntroScreen> createState() => _BusinessIntroScreenState();
}

class _BusinessIntroScreenState extends State<BusinessIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Welcome', style: GoogleFonts.inter(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  'assets/images/logos/favicon_1.png',
                  height: 100,
                  width: 100,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/logos/logo.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tell us about your business',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textDark),
              ),
              const SizedBox(height: 12),
              Text(
                'A few quick details will help Ledgerly customise insights, profits and product recommendations for your business.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.textGrey),
              ),
              const SizedBox(height: 28),

              // Short bullet points
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bullet('Track sales and expenses automatically'),
                  const SizedBox(height: 8),
                  _bullet('Get personalized profit insights'),
                  const SizedBox(height: 8),
                  _bullet('Manage products and stock easily'),
                ],
              ),

              const Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  try {
                    // Use explicit route to avoid named-route resolution issues
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (ctx) => const BusinessScreen()),
                    );
                  } catch (e, st) {
                    // Log and show user-friendly message
                    debugPrint('Navigation to BusinessScreen failed: $e\n$st');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open business setup.')),
                    );
                  }
                },
                child: Text('Set up my business', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                child: Text('Skip for now', style: GoogleFonts.inter(color: AppColors.textDark, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00A79D))),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textDark))),
      ],
    );
  }
}
