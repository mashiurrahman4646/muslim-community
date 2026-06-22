import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/jummarole/auth/service/jumma_login_service.dart';
import 'package:muslim_community/services/tokenservice.dart';

class JummaLoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  final JummaLoginService _loginService = JummaLoginService();
  final TokenService _tokenService = TokenService();

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter email and password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _loginService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final accessToken =
            data['data']?['accessToken'] ??
            data['accessToken'] ??
            data['token'];
        final refreshToken =
            data['data']?['refreshToken'] ?? data['refreshToken'];

        if (accessToken != null) {
          final role = _tokenService.getRoleFromToken(accessToken);

          // Allow 'jumma' or 'jummah' role
          if (role != 'jumma' && role != 'jummah') {
            isLoading.value = false;
            Get.snackbar(
              'Login Failed',
              'This account is not registered as a Jumma role',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }

          await _tokenService.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken ?? '',
            fallbackRole: 'jumma',
          );

          Get.snackbar(
            'Success',
            'Logged in successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offAllNamed(AppRoutes.jummaNavbar);
        } else {
          Get.snackbar(
            'Error',
            'Token not found in response',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Login Failed',
          data['message'] ?? 'An error occurred',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
