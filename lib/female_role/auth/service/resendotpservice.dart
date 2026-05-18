import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';

class FemaleResendOtpService {
  Future<http.Response> resendOtp({required String email}) async {
    final uri = Uri.parse("${AppConfig.baseUrl}/auth/resend-otp");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );
    return response;
  }
}
