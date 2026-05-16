import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:muslim_community/app_config.dart';

class FemaleCreateAccountService {
  Future<http.Response> createAccount({
    required String name,
    required String email,
    required String password,
    required String role,
    required String dateOfBirth,
    String? revertDate,
    required File verificationImage,
    required File verificationVideo,
  }) async {
    final uri = Uri.parse(AppConfig.createUserEndpoint);
    final request = http.MultipartRequest('POST', uri);

    // Add text fields
    request.fields.addAll({
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'dateOfBirth': dateOfBirth,
    });
    
    if (revertDate != null) {
      request.fields['revertDate'] = revertDate;
    }

    // Add Image file
    request.files.add(await http.MultipartFile.fromPath(
      'verificationImage',
      verificationImage.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    // Add Video file
    request.files.add(await http.MultipartFile.fromPath(
      'verificationVideo',
      verificationVideo.path,
      contentType: MediaType('video', 'mp4'),
    ));

    // Send request and convert StreamedResponse to regular Response
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
