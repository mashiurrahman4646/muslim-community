import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    
    // Increased duration for a slower, more deliberate "tik... tik..." effect
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();

    // Slower triple pulse with pauses in between
    scaleAnimation = TweenSequence<double>([
      // First "tik"
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 6),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 6),
      // Pause ........
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 15),
      
      // Second "tik"
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 6),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 6),
      // Pause .........
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 15),
      
      // Third "tik"
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 6),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 6),
      
      // Long Pause before next cycle
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 24),
    ]).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut, // Use easeInOut for smoother pulse
    ));
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
