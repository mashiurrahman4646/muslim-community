import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class PrayerGuideService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getPrayerGuide(String salahType) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.getNamazGuideEndpoint(salahType));
    
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
