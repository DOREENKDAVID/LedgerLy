import 'dart:async';
import 'package:flutter/material.dart';

class MultiStageSplashScreen extends StatefulWidget {
  const MultiStageSplashScreen({super.key});

  @override
  State<MultiStageSplashScreen> createState() => _MultiStageSplashScreenState();
}

class _MultiStageSplashScreenState extends State<MultiStageSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;

  late Animation<Offset> _animation1;
  late Animation<Offset> _animation2;
  late Animation<Offset> _animation3;
  late Animation<Offset> _animation4;

  late AnimationController _logoController;
  late Animation<double> _logoFadeIn;
  late Animation<double> _logoScale;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAnimations();
      setState(() => _isInitialized = true);
      _startAnimations();
    });
  }

  void _initializeAnimations() {
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation1 = Tween<Offset>(begin: Offset.zero, end: const Offset(-2, 0))
        .animate(CurvedAnimation(parent: _controller1, curve: Curves.easeInOut));
    _animation2 = Tween<Offset>(begin: Offset.zero, end: const Offset(2, 0))
        .animate(CurvedAnimation(parent: _controller2, curve: Curves.easeInOut));
    _animation3 = Tween<Offset>(begin: Offset.zero, end: const Offset(-2, 0))
        .animate(CurvedAnimation(parent: _controller3, curve: Curves.easeInOut));
    _animation4 = Tween<Offset>(begin: Offset.zero, end: const Offset(2, 0))
        .animate(CurvedAnimation(parent: _controller4, curve: Curves.easeInOut));

    _logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _logoFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.easeIn));
    _logoScale = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.easeInOut));
  }

  Future<void> _startAnimations() async {
    await _controller1.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _controller2.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _controller3.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _controller4.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoController.forward();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Splash Screen background
          Container(color: const Color(0xFFE0F2F1)),

          // Animated rectangles
          SlideTransition(
            position: _animation1,
            child: _buildRectangle(
                const Color(0xFF00897B), screenWidth, screenHeight, Alignment.topLeft),
          ),
          SlideTransition(
            position: _animation2,
            child: _buildRectangle(
                const Color(0xFF00897B), screenWidth, screenHeight, Alignment.topRight),
          ),
          SlideTransition(
            position: _animation3,
            child: _buildRectangle(
                const Color(0xFF00897B), screenWidth, screenHeight, Alignment.bottomLeft),
          ),
          SlideTransition(
            position: _animation4,
            child: _buildRectangle(
                const Color(0xFF00897B), screenWidth, screenHeight, Alignment.bottomRight),
          ),

          // Logo
          Center(
            child: FadeTransition(
              opacity: _logoFadeIn,
              child: ScaleTransition(
                scale: _logoScale,
                child: Image.asset('assets/images/ledgerly_logo.png',
                    width: 150, height: 150),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRectangle(
      Color color, double screenWidth, double screenHeight, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: screenWidth / 2,
        height: screenHeight / 2,
        color: color,
      ),
    );
  }
}