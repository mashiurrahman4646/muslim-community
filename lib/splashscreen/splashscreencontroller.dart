import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();

    // Increased duration for a slower, more deliberate "tik... tik..." effect
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500), // Increased duration for a slower, more calm effect
    )..repeat();

    // Smooth heartbeat effect: Grows relatively quickly, then shrinks slowly
    scaleAnimation = TweenSequence<double>([
      // Growing phase (faster)
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      // Shrinking phase (slower and smoother)
      TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 60,
      ),
    ]).animate(animationController);
    // Navigate after 5 seconds
    navigateToNext();
  }

  void navigateToNext() async {
    await Future.delayed(const Duration(seconds: 5));
    Get.offAllNamed('/selectRole');
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
