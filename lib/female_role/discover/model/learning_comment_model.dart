class LearningCommentModel {
  final String id;
  final String content;
  final String userName;
  final String userImage;
  final String? parentCommentId;
  final DateTime createdAt;
  final String userId;

  LearningCommentModel({
    required this.id,
    required this.content,
    required this.userName,
    required this.userImage,
    this.parentCommentId,
    required this.createdAt,
    required this.userId,
  });

  factory LearningCommentModel.fromJson(Map<String, dynamic> json) {
    // Handling nested author/user objects or flat strings
    final rawUser = json['user'] ?? json['userId'];
    String name = 'Anonymous';
    String image = '';
    String uId = '';
    
    if (rawUser is Map) {
      name = rawUser['fullName'] ?? rawUser['name'] ?? 'Anonymous';
      image = rawUser['profileImage'] ?? rawUser['avatar'] ?? '';
      uId = rawUser['_id']?.toString() ?? rawUser['id']?.toString() ?? '';
    } else if (rawUser is String) {
      name = json['userName'] ?? 'Anonymous';
      image = json['userImage'] ?? '';
      uId = rawUser;
    } else {
      name = json['userName'] ?? 'Anonymous';
      image = json['userImage'] ?? '';
      uId = json['userId']?.toString() ?? '';
    }

    return LearningCommentModel(
      id: json['id'] ?? json['_id'] ?? '',
      content: json['comment'] ?? json['content'] ?? json['text'] ?? '',
      userName: name,
      userImage: image,
      parentCommentId: json['parentCommentId'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      userId: uId,
    );
  }
}
