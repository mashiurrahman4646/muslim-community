import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class FemaleConnectionService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getPendingRequests() async {
    final token = await _tokenService.getToken();
    // Try base endpoint as per user's Postman test, backend might handle default type
    final uri = Uri.parse(AppConfig.pendingConnectionsEndpoint).replace(
      queryParameters: {'type': 'received'}
    );

    print("Fetching pending requests from: $uri");
    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> updateConnectionStatus(String connectionId, String action) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse("${AppConfig.updateConnectionEndpoint}/$connectionId");

    return await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "action": action // 'ACCEPT' or 'REJECT'
      }),
    );
  }
}
