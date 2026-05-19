import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class MaleLearningService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getLearningContents() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.learningContentsEndpoint);

    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> toggleLike(String contentId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.likeLearningContentEndpoint.replaceFirst('{id}', contentId));

    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> getComments(String contentId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.learningCommentsEndpoint.replaceFirst('{id}', contentId));

    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> addComment(String contentId, String comment, {String? parentCommentId}) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.learningCommentsEndpoint.replaceFirst('{id}', contentId));

    final Map<String, dynamic> bodyMap = {
      'comment': comment,
    };
    if (parentCommentId != null) {
      bodyMap['parentCommentId'] = parentCommentId;
    }

    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(bodyMap),
    );
  }

  Future<http.Response> deleteComment(String commentId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.deleteLearningCommentEndpoint.replaceFirst('{id}', commentId));

    return await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
