import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/auth/service/male_otp_service.dart';
import 'package:muslim_community/approut.dart';

class MaleOtpController extends GetxController {
  final MaleOtpService _service = MaleOtpService();
  
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  
  var isLoading = false.obs;
  var email = "".obs;

  // Timer logic
  var secondsRemaining = 300.obs; // 5 minutes
  var timerText = "05:00".obs;
  dynamic timerSubscription;

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments
    if (Get.arguments != null && Get.arguments['email'] != null) {
      email.value = Get.arguments['email'];
    }
    startTimer();
  }

  void startTimer() {
    secondsRemaining.value = 300;
    timerSubscription?.cancel();
    timerSubscription = Stream.periodic(const Duration(seconds: 1), (i) => i).listen((_) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
        int minutes = secondsRemaining.value ~/ 60;
        int seconds = secondsRemaining.value % 60;
        timerText.value = "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      } else {
        timerSubscription.cancel();
      }
    });
  }

  String get otp => otpControllers.map((c) => c.text).join();

  Future<void> verifyOtp() async {
    if (otp.length < 6) {
      Get.snackbar('Error', 'Please enter a 6-digit OTP');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.verifyOtp(
        email: email.value,
        otp: otp,
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'OTP Verified successfully!');
        Get.toNamed(AppRoutes.maleVerificationComplete);
      } else {
        Get.snackbar('Error', decodedData['message'] ?? 'Verification failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    timerSubscription?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
