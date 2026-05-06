class ChatMessageModel {
  final String id;
  final String text;
  final String time;
  final bool isMe;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
  });
}
