import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();

    // Slowed down for a calmer, more deliberate breathing rhythm
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500), // 4.5 seconds per cycle for a very slow, calm effect
    )..repeat();

    // Symmetrical heartbeat for a smoother, more premium feel
    scaleAnimation = TweenSequence<double>([
      // Growing phase (Natural inhalation)
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.22)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      // Shrinking phase (Natural exhalation)
      TweenSequenceItem(
        tween: Tween(begin: 1.22, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(animationController);

    // Smooth fade synchronized with breathing
    fadeAnimation = TweenSequence<double>([
      // Fading in smoothly
      TweenSequenceItem(
        tween: Tween(begin: 0.5, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      // Fading out smoothly
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.5)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(animationController);

    // Navigate after 8 seconds
    navigateToNext();
  }

  void navigateToNext() async {
    await Future.delayed(const Duration(seconds: 8));
    Get.offAllNamed('/selectRole');
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
