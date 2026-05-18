import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class MaleRequestSendService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> sendConnectionRequest(String userId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse("${AppConfig.connectionRequestEndpoint}/$userId");

    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
