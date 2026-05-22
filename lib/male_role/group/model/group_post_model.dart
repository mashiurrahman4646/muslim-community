import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/utils/date_formatter.dart';

class GroupPostModel {
  final String id;
  final String groupId;
  final String userId;
  final String userName;
  final String userImage;
  final String content;
  final List<String> attachments;
  final int likesCount;
  final int commentsCount;
  final bool isPinned;
  final bool isLiked;
  final String createdAt;

  GroupPostModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.attachments,
    required this.likesCount,
    required this.commentsCount,
    required this.isPinned,
    required this.isLiked,
    required this.createdAt,
  });

  factory GroupPostModel.fromJson(Map<String, dynamic> json) {
    // Look for user info in multiple possible fields
    final userVal = json['userId'] ?? json['user'] ?? json['author'] ?? json['creator'];
    String uId = '';
    String uName = 'User';
    String uImage = '';

    if (userVal is Map) {
      uId = userVal['id']?.toString() ?? userVal['_id']?.toString() ?? '';
      uName = userVal['name']?.toString() ?? userVal['username']?.toString() ?? 'User';
      uImage = userVal['profileImage']?.toString() ?? 
               userVal['image']?.toString() ?? 
               userVal['avatar']?.toString() ?? '';
    } else if (userVal is String) {
      uId = userVal;
    }

    if (uImage.isNotEmpty) {
      uImage = uImage.replaceAll('`', '').trim();
      if (!uImage.startsWith('http')) {
        final serverRoot = AppConfig.baseUrl.replaceAll('/api/v1', '');
        if (!uImage.startsWith('/')) {
          uImage = '$serverRoot/$uImage';
        } else {
          uImage = '$serverRoot$uImage';
        }
      }
    }

    return GroupPostModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      groupId: json['groupId']?.toString() ?? '',
      userId: uId,
      userName: uName,
      userImage: uImage,
      content: json['content']?.toString() ?? '',
      attachments: (json['attachments'] as List?)?.map((e) {
        String url = e.toString();
        if (url.isNotEmpty && !url.startsWith('http')) {
          final serverRoot = AppConfig.baseUrl.replaceAll('/api/v1', '');
          if (!url.startsWith('/')) {
            return '$serverRoot/$url';
          } else {
            return '$serverRoot$url';
          }
        }
        return url;
      }).toList() ?? [],
      likesCount: json['likesCount'] is int ? json['likesCount'] : int.tryParse(json['likesCount']?.toString() ?? '0') ?? 0,
      commentsCount: json['commentsCount'] is int ? json['commentsCount'] : int.tryParse(json['commentsCount']?.toString() ?? '0') ?? 0,
      isPinned: json['isPinned'] == true,
      isLiked: json['isLiked'] == true,
      createdAt: DateFormatter.formatPostTime(json['createdAt']?.toString() ?? ''),
    );
  }
}
