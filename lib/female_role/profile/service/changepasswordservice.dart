import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class FemaleChangePasswordService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.changePasswordEndpoint);
    
    return await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
  }
}
