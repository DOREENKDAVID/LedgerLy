import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/auth/screens/sign_up_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Meet Your AI-Powered Financial Partner",
      "subtitle": "Make smarter decisions and grow your profit with clarity.",
      "image": "assets/images/onboarding_1.png",
    },
    {
      "title": "Selling Every Day, But Still Unsure Of Profit?",
      "subtitle": "Know which products actually earn you money.",
      "image": "assets/images/onboarding_2.png",
    },
    {
      "title": "Turn Numbers Into Actionable Insights",
      "subtitle":
          "Interpret your sales and expenses so you know exactly what to do next.",
      "image": "assets/images/onboarding_3.png",
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),

            // Carousel Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) => _buildPage(index),
              ),
            ),

            // Bottom Actions (Indicator + Button)
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 30),
                  LedgerlyButton(
                    label: _currentPage == _onboardingData.length - 1
                        ? "Get Started"
                        : "Continue",
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            _onboardingData[index]["image"]!,
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          _buildColoredTitle(index),
          const SizedBox(height: 15),
          Text(
            _onboardingData[index]["subtitle"]!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColoredTitle(int index) {
    final baseStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryTeal,
    );
    final highlightStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.accentOrange,
    );

    late TextSpan titleSpan;

    if (index == 0) {
      // Screen 1: "Meet Your AI-Powered Financial Partner"
      titleSpan = TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: "Meet Your ", style: baseStyle),
          TextSpan(text: "AI-Powered", style: highlightStyle),
          TextSpan(text: " Financial Partner", style: baseStyle),
        ],
      );
    } else if (index == 1) {
      // Screen 2: "Selling Every Day, But Still Unsure Of Profit?"
      titleSpan = TextSpan(
        style: baseStyle,
        children: [
          TextSpan(
              text: "Selling Every Day, But Still Unsure Of ",
              style: baseStyle),
          TextSpan(text: "Profit?", style: highlightStyle),
        ],
      );
    } else {
      // Screen 3: "Turn Numbers Into Actionable Insights"
      titleSpan = TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: "Turn Numbers Into ", style: baseStyle),
          TextSpan(text: "Actionable", style: highlightStyle),
          TextSpan(text: " Insights", style: baseStyle),
        ],
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: titleSpan,
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppColors.primaryTeal
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
