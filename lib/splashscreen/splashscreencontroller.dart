import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/services/tokenservice.dart';

class SplashScreenController extends GetxController
    with GetTickerProviderStateMixin {
  
  // Animation Controllers
  late AnimationController introController;
  late AnimationController rotationController;
  late AnimationController pulseController;
  late AnimationController progressController;

  // Staggered Animations
  late Animation<double> logoScale;
  late Animation<double> logoFade;
  late Animation<double> bgPatternFade;
  late Animation<double> titleFade;
  late Animation<double> titleSlide;
  late Animation<double> dividerWidthPercent; // 0.0 to 1.0
  late Animation<double> quoteFade;
  late Animation<double> quoteSlide;
  late Animation<double> loadingFade;

  // Continuous loop animations
  late Animation<double> logoGlow;
  late Animation<double> rotationAngle;

  @override
  void onInit() {
    super.onInit();

    // 1. Intro Controller (Entrance sequence of UI elements)
    introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // 2. Pulse Controller (Subtle breathing effect for aura)
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    // 3. Rotation Controller (Very slow background pattern rotation)
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();

    // 4. Progress Controller (Controls filling of the loading indicator)
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );

    // --- Staggered Animation Definitions ---

    // Logo Scales from 0 to 1 with an elastic feel
    logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    // Logo Fades in
    logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    // Background Pattern Fades in
    bgPatternFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.15, 0.55, curve: Curves.easeIn),
      ),
    );

    // Title Fades in
    titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    // Title Slides up (represented by negative offset value)
    titleSlide = Tween<double>(begin: 25.0, end: 0.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // Divider Line expands from center
    dividerWidthPercent = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    // Quote Fades in
    quoteFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    // Quote Slides up
    quoteSlide = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    // Loading Bar and Text Fades in at the end
    loadingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    // --- Loop Animation Definitions ---

    // Logo shadow breathing effect
    logoGlow = Tween<double>(begin: 0.3, end: 0.85).animate(
      CurvedAnimation(
        parent: pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Background Rotation
    rotationAngle = Tween<double>(begin: 0.0, end: 2 * 3.141592653589793).animate(
      rotationController,
    );

    // Start Intro Sequence
    introController.forward();

    // Start Simulated Progress. Once it completes, transition to next screen.
    progressController.forward().then((_) {
      navigateToNext();
    });
  }

  void navigateToNext() async {
    final TokenService tokenService = TokenService();
    final String? token = await tokenService.getToken();
    final String? role = await tokenService.getRole();

    // Small delay to let progress indicator feel finished before switching
    await Future.delayed(const Duration(milliseconds: 300));

    if (token != null && token.isNotEmpty) {
      if (role == 'male') {
        Get.offAllNamed(AppRoutes.maleNavbar);
      } else if (role == 'female') {
        Get.offAllNamed(AppRoutes.femaleNavbar);
      } else if (role == 'jumma') {
        Get.offAllNamed(AppRoutes.jummaNavbar);
      } else {
        Get.offAllNamed(AppRoutes.selectRole);
      }
    } else {
      Get.offAllNamed(AppRoutes.selectRole);
    }
  }

  @override
  void onClose() {
    introController.dispose();
    rotationController.dispose();
    pulseController.dispose();
    progressController.dispose();
    super.onClose();
  }
}
