import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class FemaleRequestCancelService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> cancelConnectionRequest(String connectionId) async {
    final token = await _tokenService.getToken();
    final url = AppConfig.cancelConnectionEndpoint.replaceAll('{id}', connectionId);
    final uri = Uri.parse(url);

    print("  🔗 Cancel URL: $url");
    print("  🔑 Token exists: ${token != null && token.isNotEmpty}");

    return await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
