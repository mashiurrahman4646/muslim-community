import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class FemaleUserDataService {
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final token = await TokenService().getToken();
      if (token == null) return null;

      final uri = Uri.parse(AppConfig.getProfileEndpoint);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
      }
    } catch (e) {
      print("Error in FemaleUserDataService: $e");
    }
    return null;
  }
}
