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
    final userVal = json['userId'];
    String uId = '';
    String uName = 'User';
    String uImage = '';

    if (userVal is Map) {
      uId = userVal['id'] ?? userVal['_id'] ?? '';
      uName = userVal['name'] ?? 'User';
      uImage = userVal['profileImage'] ?? '';
    } else if (userVal is String) {
      uId = userVal;
    }

    if (uImage.isNotEmpty) {
      uImage = uImage.replaceAll('`', '').trim();
    }

    return GroupPostModel(
      id: json['id'] ?? json['_id'] ?? '',
      groupId: json['groupId'] ?? '',
      userId: uId,
      userName: uName,
      userImage: uImage,
      content: json['content'] ?? '',
      attachments: List<String>.from(json['attachments'] ?? []),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      isPinned: json['isPinned'] ?? false,
      isLiked: json['isLiked'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
