import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class MaleChatService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getChatList() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.chatListEndpoint);
    
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> getChatMessages(String chatId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.getChatMessagesEndpoint(chatId));
    
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.StreamedResponse> sendMessage(String chatId, String text) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.messagesEndpoint);
    
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['chatId'] = chatId;
    request.fields['text'] = text;
    
    return await request.send();
  }
}
