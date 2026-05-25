import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:corporate_filter/screens/home.screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Controller set for 3.5 seconds to complete the cycle before navigation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // 2. Zoom-In Phase (0.0 -> 0.4): Smoothly pops up from small size to full size
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    // 3. Fade-Out Phase (0.7 -> 1.0): Dissolves completely to transparent
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Kick off the text animation
    _animationController.forward();

    // 4. Exact 4-second transition delay to the next screen
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // The static background gradient designed to replicate the Gemini UI center glow
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.1, // Controls how far out the blue mist extends
            colors: [
              Color.fromARGB(255, 27, 56, 119,), // Deep midnight blue aura in the absolute center
              Color(0xFF080B11,), // Blends into the signature near-black dark mode
              Color(0xFF050505), // Complete dark periphery edges
            ],
            stops: [0.0, 0.6, 0.75,], // Defines where the transition changes happen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/svg/icon01.svg",
                height: 65,
                width: 65,
                fit: BoxFit.cover,
              ),
              Gap(32),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      "Corporate Translation Layer",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(
                          0xFFE2E8F0,
                        ), // Clean, high-contrast off-white
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.45,
                      ),
                    ),
                    Gap(4),
                    Text(
                      "- The AI Filter Between You and Termination.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(
                          0xFFE2E8F0,
                        ), // Clean, high-contrast off-white
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
