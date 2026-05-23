import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class JummaChangePasswordService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.changePasswordEndpoint);
    
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    
    return response;
  }
}
