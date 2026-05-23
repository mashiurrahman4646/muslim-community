import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';

class JummaSignupService {
  Future<http.Response> createAccount({
    required String name,
    required String email,
    required String password,
    required String role,
    required String dateOfBirth,
  }) async {
    final uri = Uri.parse(AppConfig.createUserEndpoint);
    final request = http.MultipartRequest('POST', uri);

    // Add text fields as form-data
    request.fields.addAll({
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'dateOfBirth': dateOfBirth,
    });

    // Send request and convert StreamedResponse to regular Response
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
