class LearningContentModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String category;
  final int durationInSeconds;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isLiked;

  LearningContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.category,
    required this.durationInSeconds,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    this.isLiked = false,
  });

  factory LearningContentModel.fromJson(Map<String, dynamic> json) {
    return LearningContentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      category: json['category'] ?? 'General',
      durationInSeconds: json['durationInSeconds'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isLiked: json['isLiked'] ?? false,
    );
  }

  String get durationText {
    final minutes = (durationInSeconds / 60).floor();
    final seconds = durationInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
