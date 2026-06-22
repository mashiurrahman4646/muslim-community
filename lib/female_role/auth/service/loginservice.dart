import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';

class FemaleLoginService {
  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(AppConfig.loginEndpoint);

    print('=== LOGIN API REQUEST ===');
    print('URL: $uri');
    print('Payload: {"email": "$email", "password": "****"}');

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 10));

    print('=== LOGIN API RESPONSE ===');
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');
    print('==========================');

    return response;
  }
}
