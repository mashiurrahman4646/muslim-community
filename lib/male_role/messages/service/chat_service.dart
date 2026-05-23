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

  Future<http.Response> getChatMessages(String chatId, {String? cursor, int limit = 20}) async {
    final token = await _tokenService.getToken();
    var url = AppConfig.getChatMessagesEndpoint(chatId);
    
    // Add query parameters for pagination
    String queryString = "limit=$limit";
    if (cursor != null && cursor.isNotEmpty) {
      queryString += "&cursor=$cursor";
    }
    
    final uri = Uri.parse("$url?$queryString");
    
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> markChatAsRead(String chatId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.markChatAsReadEndpoint(chatId));
    
    return await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> sendMessage(String chatId, String text) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.messagesEndpoint);
    
    print("CHAT_DEBUG: Sending message to $uri");
    print("CHAT_DEBUG: Fields: chatid=$chatId, text=$text");

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    // Changed 'chatid' to 'chatId' (camelCase) to fix 400 Invalid chatId error
    request.fields['chatId'] = chatId;
    request.fields['text'] = text;
    
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    
    print("CHAT_DEBUG: Status Code: ${response.statusCode}");
    print("CHAT_DEBUG: Response Body: ${response.body}");
    
    return response;
  }
}
