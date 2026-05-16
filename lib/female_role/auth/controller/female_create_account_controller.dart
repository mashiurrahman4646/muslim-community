import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/auth/service/female_create_account_service.dart';
import 'package:muslim_community/female_role/auth/controller/female_verify_controller.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../../approut.dart';

class FemaleCreateAccountController extends GetxController {
  final FemaleCreateAccountService _service = FemaleCreateAccountService();
  final FemaleVerifyController verifyController = Get.put(FemaleVerifyController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  var role = "SISTER".obs;
  var dateOfBirth = "".obs;
  var revertDate = "".obs;
  
  var isLoading = false.obs;

  void setRole(String selectedRole) {
    role.value = selectedRole;
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfBirth.value = picked.toUtc().toIso8601String();
    }
  }

  Future<void> pickRevertDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      revertDate.value = picked.toUtc().toIso8601String();
    }
  }

  void validateAndNext() {
    String missingFields = "";
    if (nameController.text.isEmpty) missingFields += "Name, ";
    if (emailController.text.isEmpty) missingFields += "Email, ";
    if (passwordController.text.isEmpty) missingFields += "Password, ";
    if (dateOfBirth.value.isEmpty) missingFields += "Date of Birth, ";

    if (missingFields.isNotEmpty) {
      String errorMsg = "Please fill: ${missingFields.substring(0, missingFields.length - 2)}";
      Get.snackbar(
        'Required Fields',
        errorMsg,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Email validation
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    // Password validation (min 8 chars)
    if (passwordController.text.length < 8) {
      Get.snackbar('Weak Password', 'Password must be at least 8 characters long.');
      return;
    }

    Get.toNamed(AppRoutes.femaleIdentityVerification);
  }

  Future<void> createAccount() async {
    // Debug Logging
    print("--- Female Registration Data Debug ---");
    print("Name: ${nameController.text}");
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
    print("Role: ${role.value}");
    print("DOB: ${dateOfBirth.value}");
    print("Revert Date: ${revertDate.value}");
    print("Image Path: ${verifyController.verificationImage.value?.path}");
    print("Video Path: ${verifyController.verificationVideo.value?.path}");
    print("-------------------------------");

    // Detailed Validation
    String missingFields = "";
    if (nameController.text.isEmpty) missingFields += "Name, ";
    if (emailController.text.isEmpty) missingFields += "Email, ";
    if (passwordController.text.isEmpty) missingFields += "Password, ";
    if (dateOfBirth.value.isEmpty) missingFields += "Date of Birth, ";
    if (verifyController.verificationImage.value == null) missingFields += "Photo, ";
    if (verifyController.verificationVideo.value == null) missingFields += "Video, ";

    if (missingFields.isNotEmpty) {
      String errorMsg = "Missing: ${missingFields.substring(0, missingFields.length - 2)}";
      print("Female Validation Error: $errorMsg");
      Get.snackbar(
        'Validation Error',
        errorMsg,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.createAccount(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        role: role.value,
        dateOfBirth: dateOfBirth.value,
        revertDate: revertDate.value.isNotEmpty ? revertDate.value : null,
        verificationImage: verifyController.verificationImage.value!,
        verificationVideo: verifyController.verificationVideo.value!,
      );

      print("Female API Response Code: ${response.statusCode}");
      print("Female API Response Body: ${response.body}");

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Account created successfully! Please verify your email.');
        Get.toNamed(AppRoutes.femaleSignUpOTP, arguments: {'email': emailController.text});
      } else {
        Get.snackbar('Error', decodedData['message'] ?? "Registration failed");
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
