import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';

class ForgetPasswordService {
  Future<http.Response> forgotPassword(String email) async {
    final uri = Uri.parse(AppConfig.forgotPasswordEndpoint);
    return await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
  }

  Future<http.Response> verifyOtp(String email, String otp) async {
    final uri = Uri.parse(AppConfig.verifyOtpEndpoint);
    return await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );
  }

  Future<http.Response> resetPassword({
    required String token,
    required String password,
  }) async {
    final uri = Uri.parse(AppConfig.resetPasswordEndpoint);
    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'newPassword': password,
      }),
    );
  }
}
