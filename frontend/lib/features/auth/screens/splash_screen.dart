import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ledgerly_v3/features/auth/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _step = 0; // 0 = Teal, 1 = White (no logo), 2 = White (logo shown)

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    // 1) 1.2s teal
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _step = 1);

    // 2) 0.8s white
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _step = 2);

    // 3) 1.5s white with logo
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = (_step == 0) ? const Color(0xFF008080) : Colors.white;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _step == 2 ? 1.0 : 0.0,
            child: _step == 2
                ? Image.asset(
                    'assets/images/logos/logo.png',
                    width: 220,
                    fit: BoxFit.contain,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
