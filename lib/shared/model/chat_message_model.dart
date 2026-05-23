import 'package:muslim_community/utils/date_formatter.dart';

enum MessageStatus { sent, delivered, read }

class ChatMessageModel {
  final String id;
  final String text;
  final String time;
  final bool isMe;
  final String? senderId;
  final String? senderName;
  MessageStatus status;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    this.senderId,
    this.senderName,
    this.status = MessageStatus.sent,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    // 1. Extract Sender ID and Name
    // Check root level first, then nested objects
    String sId = (json['senderId'] ?? json['userId'] ?? json['creatorId'] ?? json['from'] ?? '').toString();
    String sName = (json['senderName'] ?? json['userName'] ?? '').toString();

    final senderData = json['sender'] ?? json['creator'] ?? json['user'] ?? json['author'];
    
    if (senderData is Map) {
      // Priority: id > _id > userId
      final idValue = senderData['id'] ?? senderData['_id'] ?? senderData['userId'];
      if (idValue != null) sId = idValue.toString();
      
      final nameValue = senderData['name'] ?? senderData['fullName'] ?? senderData['userName'];
      if (nameValue != null) sName = nameValue.toString();
    } else if (senderData is String && sId.isEmpty) {
      sId = senderData;
    }
    
    // 2. Ultra-Aggressive Fallback: Scan ALL root keys for a 24-char hex string (MongoDB ID)
    if (sId.isEmpty || sId == 'null') {
      json.forEach((key, value) {
        if (value is String && value.length == 24 && RegExp(r'^[0-9a-fA-F]+$').hasMatch(value)) {
          final lowKey = key.toLowerCase();
          if (lowKey.contains('id') || lowKey.contains('user') || lowKey.contains('sender') || lowKey.contains('creator') || lowKey.contains('from')) {
             sId = value;
          }
        }
      });
    }

    // 3. Final Cleanup
    sId = sId.trim();
    if (sId == 'null' || sId.isEmpty) sId = '';
    if (sName.isEmpty || sName == 'null') sName = 'User';

    // 6. Robust Comparison for isMe
    bool isMe = false;
    if (sId.isNotEmpty && currentUserId.isNotEmpty) {
      isMe = sId.toLowerCase() == currentUserId.trim().toLowerCase();
    }
    
    print("CHAT_DEBUG: isMe calculated: $isMe for msg: '${json['text'] ?? '...'}'");

    // Simple, clean debug log
    if (sId.isEmpty) {
      print("CHAT_MODEL: ⚠️ Missing SenderID for msg: '${json['text']}'");
    }

    // Parse status
    MessageStatus msgStatus = MessageStatus.sent;
    if (json['isRead'] == true || (json['readBy'] != null && (json['readBy'] as List).isNotEmpty) || json['status'] == 'read') {
      msgStatus = MessageStatus.read;
    } else if (json['isDelivered'] == true || json['deliveredAt'] != null || json['status'] == 'delivered') {
      msgStatus = MessageStatus.delivered;
    }

    return ChatMessageModel(
      id: (json['id'] ?? json['_id'] ?? json['messageId'] ?? DateTime.now().millisecondsSinceEpoch.toString()).toString(),
      text: (json['text'] ?? json['content'] ?? json['message'] ?? '').toString(),
      time: DateFormatter.formatChatTime(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isMe: isMe,
      senderId: sId,
      senderName: sName,
      status: msgStatus,
    );
  }

  // Helper for optimistic UI update
  factory ChatMessageModel.optimistic({
    required String text,
    required String myId,
    required String myName,
  }) {
    return ChatMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      time: DateFormatter.formatChatTime(DateTime.now().toIso8601String()),
      isMe: true,
      senderId: myId,
      senderName: myName,
      status: MessageStatus.sent,
    );
  }
}
