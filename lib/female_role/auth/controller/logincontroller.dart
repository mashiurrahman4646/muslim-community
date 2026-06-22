import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/female_role/auth/service/loginservice.dart';
import 'package:muslim_community/services/tokenservice.dart';
import 'package:muslim_community/female_role/home/controller/locationcontroller.dart';

class FemaleLoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final emailError = "".obs;
  final passwordError = "".obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  final FemaleLoginService _loginService = FemaleLoginService();
  final TokenService _tokenService = TokenService();

  Future<void> login() async {
    emailError.value = "";
    passwordError.value = "";
    bool isValid = true;

    if (emailController.text.trim().isEmpty) {
      emailError.value = "Email is required";
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = "Please enter a valid email address";
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = "Password is required";
      isValid = false;
    }

    if (!isValid) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await _loginService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        final accessToken = data['data']?['accessToken'] ?? data['accessToken'] ?? data['token'];
        final refreshToken = data['data']?['refreshToken'] ?? data['refreshToken'];

        if (accessToken != null) {
          final role = _tokenService.getRoleFromToken(accessToken);
          
          if (role != 'female' && role != 'sister') {
            isLoading.value = false;
            Get.snackbar('Login Failed', 'This account is not registered as a Sister',
                backgroundColor: Colors.red, colorText: Colors.white);
            return;
          }

          await _tokenService.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken ?? '',
            fallbackRole: 'female',
          );
          
          try {
            final locationController = Get.put(FemaleLocationController());
            await locationController.updateUserLocation(accessToken);
          } catch (e) {
            print("Location update failed during login: $e");
          }

          Get.snackbar('Success', 'Logged in successfully',
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.offAllNamed(AppRoutes.femaleNavbar);
        } else {
          Get.snackbar('Error', 'Token not found in response',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Login Failed', data['message'] ?? 'An error occurred',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      String errorMessage = 'Something went wrong. Please try again.';
      if (e is SocketException || 
          e is TimeoutException || 
          e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException') || 
          e.toString().contains('ClientException') ||
          e.toString().contains('HandshakeException')) {
        errorMessage = 'Server is not responding. Please try again later.';
      } else {
        errorMessage = 'Something went wrong: $e';
      }
      Get.snackbar('Error', errorMessage,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
