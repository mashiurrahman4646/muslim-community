import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';

class FemaleOtpService {
  Future<http.Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final uri = Uri.parse(AppConfig.verifyOtpEndpoint);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );
    return response;
  }
}
