import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';
import 'package:mime/mime.dart';

class JummaProfileEditService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> updateProfile({
    String? name,
    String? dateOfBirth,
    String? revertDate, // Used for "How long you are imam"
    File? profileImage,
  }) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('${AppConfig.baseUrl}/users/me');
    
    final request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = 'Bearer $token';

    if (name != null) request.fields['name'] = name;
    // Removed dateOfBirth and revertDate from patch as requested

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
