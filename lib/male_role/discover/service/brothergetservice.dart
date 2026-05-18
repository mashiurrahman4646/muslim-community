import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class BrotherGetService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getProfiles({
    required double latitude,
    required double longitude,
    String? searchTerm,
    String? filter,
    int page = 1,
    int limit = 10,
  }) async {
    final token = await _tokenService.getToken();
    
    final queryParameters = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParameters['searchTerm'] = searchTerm;
    }
    
    if (filter != null && filter.isNotEmpty) {
      queryParameters['filter'] = filter;
    }
    
    final uri = Uri.parse(AppConfig.getProfilesEndpoint)
        .replace(queryParameters: queryParameters);
        
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
