import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/auth/service/resendotpservice.dart';

class MaleResendOtpController extends GetxController {
  final MaleResendOtpService _service = MaleResendOtpService();
  var isLoading = false.obs;

  Future<void> resendOtp(String email, Function onTimerReset) async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email not found');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.resendOtp(email: email);
      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'OTP resent successfully!');
        onTimerReset(); // Callback to reset timer in the main OTP controller
      } else {
        Get.snackbar('Error', decodedData['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. $e');
    } finally {
      isLoading.value = false;
    }
  }
}
