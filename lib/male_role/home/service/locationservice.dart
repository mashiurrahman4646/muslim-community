import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';

class MaleLocationService {
  Future<http.Response> patchLocation({
    required String accessToken,
    required double latitude,
    required double longitude,
    required String country,
    required String city,
  }) async {
    final uri = Uri.parse("${AppConfig.baseUrl}/users/me");
    final request = http.MultipartRequest('PATCH', uri);
    
    request.headers.addAll({
      'Authorization': 'Bearer $accessToken',
    });
    
    request.fields.addAll({
      'location[country]': country,
      'location[city]': city,
      'location[latitude]': latitude.toString(),
      'location[longitude]': longitude.toString(),
    });
    
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
