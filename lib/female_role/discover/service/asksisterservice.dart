import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class AskSisterService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> submitQuestion(String question) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.askQuestionEndpoint);

    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'question': question,
      }),
    );
  }

  Future<http.Response> getMyQuestions() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.myQuestionsEndpoint);

    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
