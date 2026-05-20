import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';
import 'package:mime/mime.dart';

class MaleProfileEditService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> updateProfile({
    String? name,
    String? aboutMe,
    String? revertStory,
    String? revertDate,
    List<String>? interests,
    File? profileImage,
    String? country,
    String? city,
    String? latitude,
    String? longitude,
  }) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('${AppConfig.baseUrl}/users/me');
    
    final request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = 'Bearer $token';

    if (name != null) request.fields['name'] = name;
    if (aboutMe != null) request.fields['aboutMe'] = aboutMe;
    if (revertStory != null) request.fields['revertStory'] = revertStory;
    if (revertDate != null) request.fields['revertDate'] = revertDate;
    
    if (interests != null) {
      request.fields['interests'] = jsonEncode(interests);
    }
    
    if (country != null) request.fields['location[country]'] = country;
    if (city != null) request.fields['location[city]'] = city;
    if (latitude != null) request.fields['location[latitude]'] = latitude;
    if (longitude != null) request.fields['location[longitude]'] = longitude;

    if (profileImage != null) {
      final mimeTypeData = lookupMimeType(profileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final mimeType = mimeTypeData != null ? mimeTypeData[0] : 'image';
      final mimeSubType = mimeTypeData != null ? mimeTypeData[1] : 'jpeg';

      request.files.add(await http.MultipartFile.fromPath(
        'profileImage',
        profileImage.path,
        contentType: MediaType(mimeType, mimeSubType),
      ));
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
