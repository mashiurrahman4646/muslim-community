import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';

class TokenService {
  static const String _accessTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _roleKey = 'user_role';

  // Save access and refresh tokens along with optional fallback role
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? fallbackRole,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    if (fallbackRole != null) {
      await prefs.setString(_roleKey, fallbackRole);
    }
  }

  // Get stored access token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Get stored refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Remove all tokens and roles (Logout)
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_roleKey);
  }

  // Parse JWT token to get the role dynamically from payload
  String? getRoleFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = parts[1];
      // Normalize base64url string padding
      String normalized = base64Url.normalize(payload);
      final decodedBytes = base64Url.decode(normalized);
      final decodedString = utf8.decode(decodedBytes);
      final Map<String, dynamic> payloadMap = jsonDecode(decodedString);
      
      // Extract role using common keys
      final rawRole = payloadMap['role']?.toString().toLowerCase() ?? 
                      payloadMap['userRole']?.toString().toLowerCase() ??
                      payloadMap['roles']?.toString().toLowerCase() ??
                      payloadMap['type']?.toString().toLowerCase();

      if (rawRole == null) return null;

      // Map roles like 'brother' or 'sister' to standard AppRoutes matching keys ('male', 'female')
      if (rawRole == 'brother') {
        return 'male';
      } else if (rawRole == 'sister') {
        return 'female';
      }
      return rawRole;
    } catch (e) {
      return null;
    }
  }

  // Get role (tries to decode JWT first, falls back to stored role)
  Future<String?> getRole() async {
    final token = await getToken();
    if (token != null) {
      final jwtRole = getRoleFromToken(token);
      if (jwtRole != null && jwtRole.isNotEmpty) {
        return jwtRole;
      }
    }
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // Refresh access token using the stored refresh token
  Future<bool> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final uri = Uri.parse(AppConfig.refreshTokenEndpoint);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['data']?['accessToken'];
        final newRefreshToken = data['data']?['refreshToken'];

        if (newAccessToken != null && newRefreshToken != null) {
          await saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          return true;
        }
      }
    } catch (e) {
      // Failed to refresh token
    }
    return false;
  }
}
