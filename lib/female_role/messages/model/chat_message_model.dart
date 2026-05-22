import 'package:muslim_community/utils/date_formatter.dart';

class ChatMessageModel {
  final String id;
  final String text;
  final String time;
  final bool isMe;
  final String? senderId;
  final String? senderName;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    this.senderId,
    this.senderName,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    final senderObj = json['sender'];
    String sId = '';
    String sName = '';
    
    if (senderObj is Map) {
      sId = senderObj['id'] ?? senderObj['_id'] ?? '';
      sName = senderObj['name'] ?? '';
    } else if (senderObj is String) {
      sId = senderObj;
    } else {
      // If sender is null, it might be an older message or special system message
      // or we can try to fallback to a field if available
      sId = json['senderId'] ?? '';
    }

    // IMPORTANT: If sId is empty but the message is retrieved, 
    // we need to be careful. However, based on your response, 
    // currentUserId will be compared with sId.
    
    return ChatMessageModel(
      id: json['id'] ?? json['_id'] ?? '',
      text: json['text'] ?? json['content'] ?? '',
      time: DateFormatter.formatChatTime(json['createdAt'] ?? ''),
      isMe: sId.isNotEmpty && sId == currentUserId,
      senderId: sId,
      senderName: sName,
    );
  }
}
