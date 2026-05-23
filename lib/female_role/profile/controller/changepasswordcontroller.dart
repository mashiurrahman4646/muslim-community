import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/profile/service/changepasswordservice.dart';

import 'package:muslim_community/services/tokenservice.dart';
import 'package:muslim_community/approut.dart';

class FemaleChangePasswordController extends GetxController {
  final FemaleChangePasswordService _service = FemaleChangePasswordService();
  final TokenService _tokenService = TokenService();

  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  var isLoading = false.obs;
  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void toggleCurrentPasswordVisibility() => isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  void toggleNewPasswordVisibility() => isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  Future<void> changePassword() async {
    if (currentPasswordCtrl.text.isEmpty || newPasswordCtrl.text.isEmpty || confirmPasswordCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
      Get.snackbar('Error', 'New passwords do not match', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.changePassword(
        currentPassword: currentPasswordCtrl.text,
        newPassword: newPasswordCtrl.text,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear token and redirect to login after password change
        await _tokenService.removeToken();
        Get.offAllNamed(AppRoutes.selectRole);
        
        Get.snackbar('Success', 'Password changed successfully. Please login again.', 
            backgroundColor: Colors.green, colorText: Colors.white, duration: const Duration(seconds: 4));
        _clearFields();
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to change password', backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Change Password Error: $e");
      Get.snackbar('Error', 'An error occurred', backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFields() {
    currentPasswordCtrl.clear();
    newPasswordCtrl.clear();
    confirmPasswordCtrl.clear();
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
