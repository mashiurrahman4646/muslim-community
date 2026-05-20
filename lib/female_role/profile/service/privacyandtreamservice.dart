import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class PrivacyAndTermsService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getLegalPages() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.legalEndpoint);
    
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> getLegalPageBySlug(String slug) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('${AppConfig.legalEndpoint}/$slug');
    
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
