import 'package:muslim_community/utils/date_formatter.dart';
import 'package:muslim_community/app_config.dart';

class MessageModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isVerified;
  final bool isGroup;
  final String? imageUrl;
  final String? participantId;

  MessageModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isVerified = false,
    this.isGroup = false,
    this.imageUrl,
    this.participantId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    final List<dynamic> participants = json['participants'] ?? [];
    
    // Find the other participant (not me)
    Map<String, dynamic>? otherParticipant;
    if (participants.isNotEmpty) {
      // Try to find by id/userId
      for (var p in participants) {
        final pid = p['id'] ?? p['_id'] ?? p['userId'];
        if (pid != null && pid != currentUserId) {
          otherParticipant = p;
          break;
        }
      }
      
      // Fallback to the first one if we can't find by id or if there's only one
      otherParticipant ??= participants[0];
    }

    final lastMsgObj = json['lastMessage'];
    String lastText = 'No messages yet';
    String rawTime = '';

    if (lastMsgObj is Map) {
      lastText = lastMsgObj['text'] ?? lastMsgObj['content'] ?? 'No messages yet';
      rawTime = lastMsgObj['createdAt'] ?? '';
    } else if (json['updatedAt'] != null) {
      rawTime = json['updatedAt'];
    } else if (json['createdAt'] != null) {
      rawTime = json['createdAt'];
    }

    String? uImage = otherParticipant?['profileImage'] ?? 
                    otherParticipant?['image'] ?? 
                    otherParticipant?['avatar'] ?? 
                    otherParticipant?['profile_image'] ??
                    otherParticipant?['profile'];
                    
    if (uImage != null && uImage.isNotEmpty) {
      uImage = uImage.replaceAll('`', '').trim();
      // If it's a relative path and not an asset path, prepend base URL
      if (!uImage.startsWith('http') && !uImage.startsWith('assets/')) {
        final serverRoot = AppConfig.baseUrl.replaceAll('/api/v1', '');
        if (!uImage.startsWith('/')) {
          uImage = '$serverRoot/$uImage';
        } else {
          uImage = '$serverRoot$uImage';
        }
      }
    }

    return MessageModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: otherParticipant?['name'] ?? otherParticipant?['fullName'] ?? 'Unknown',
      lastMessage: lastText,
      time: DateFormatter.formatChatTime(rawTime),
      unreadCount: json['unreadCount'] ?? 0,
      imageUrl: uImage,
      participantId: otherParticipant?['id'] ?? otherParticipant?['_id'] ?? otherParticipant?['userId'],
    );
  }
}
