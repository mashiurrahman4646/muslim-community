class MessageModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isVerified;
  final bool isGroup;
  final String? imageUrl;

  MessageModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isVerified = false,
    this.isGroup = false,
    this.imageUrl,
  });
}
