import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class DuaService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getDuas() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.duasEndpoint);
    
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> getDuaByWaqt(String waqt) async {
    final token = await _tokenService.getToken();
    // Assuming the API supports filtering by waqt via query params
    final uri = Uri.parse(AppConfig.duasEndpoint).replace(queryParameters: {'waqt': waqt});
    
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
