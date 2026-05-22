import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class FemaleConnectionService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getPendingRequests() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.pendingConnectionsEndpoint).replace(
      queryParameters: {'direction': 'received'}
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

  Future<http.Response> getSentRequests({String? nextCursor}) async {
    final token = await _tokenService.getToken();
    final Map<String, String> queryParams = {
      'direction': 'sent',
      'limit': '10',
      'sort': '-createdAt',
      'fields': 'status,createdAt'
    };
    if (nextCursor != null) queryParams['nextCursor'] = nextCursor;

    final uri = Uri.parse(AppConfig.pendingConnectionsEndpoint).replace(
      queryParameters: queryParams
    );

    print("Fetching sent requests from: $uri");
    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> getMyNotifications() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.prayersNotificationsEndpoint);

    print("🚀 GET NOTIFICATIONS: $uri");
    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> markNotificationAsRead(String notificationId) async {
    final token = await _tokenService.getToken();
    final url = AppConfig.markNotificationReadEndpoint.replaceAll('{id}', notificationId);
    final uri = Uri.parse(url);

    print("🚀 MARK NOTIFICATION READ: $uri");
    return await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> markAllNotificationsAsRead() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.markAllNotificationsReadEndpoint);

    print("🚀 MARK ALL NOTIFICATIONS READ: $uri");
    return await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> acceptConnection(String connectionId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse("${AppConfig.connectionsEndpoint}/$connectionId/accept");

    print("🚀 ACCEPT API CALL: $uri");
    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({}),
    );
  }

  Future<http.Response> rejectConnection(String connectionId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse("${AppConfig.connectionsEndpoint}/$connectionId/reject");

    print("🚀 REJECT API CALL: $uri");
    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({}),
    );
  }

  Future<http.Response> cancelConnection(String connectionId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse("${AppConfig.connectionsEndpoint}/$connectionId/cancel");

    print("🚀 CANCEL API CALL: $uri");
    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({}),
    );
  }

  Future<http.Response> updateConnectionStatus(String connectionId, String action) async {
    if (action == 'ACCEPT') return acceptConnection(connectionId);
    if (action == 'REJECT') return rejectConnection(connectionId);
    
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
