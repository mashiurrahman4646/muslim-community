import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class FemalePrayerTimeService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getPrayerTimes(double latitude, double longitude) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('${AppConfig.prayerTimesEndpoint}?latitude=$latitude&longitude=$longitude');
    
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
