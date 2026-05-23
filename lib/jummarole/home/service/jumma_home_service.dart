import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class JummaHomeService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getKhutbahs() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse("${AppConfig.baseUrl}/khutba");

    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> getKhutbahById({required String khutbahId}) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse("${AppConfig.baseUrl}/khutba/$khutbahId");

    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
