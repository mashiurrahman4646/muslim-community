import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';

class JummaLoginService {
  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(AppConfig.loginEndpoint);
    
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    return response;
  }
}
