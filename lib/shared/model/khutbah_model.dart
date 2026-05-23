class KhutbahModel {
  final String id;
  final String title;
  final String mosqueName;
  final String imam;
  final DateTime date;
  final String description;
  final String audioUrl;
  final String thumbnailUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  KhutbahModel({
    required this.id,
    required this.title,
    required this.mosqueName,
    required this.imam,
    required this.date,
    required this.description,
    required this.audioUrl,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KhutbahModel.fromJson(Map<String, dynamic> json) {
    return KhutbahModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? 'Blessed Khutbah',
      mosqueName: json['mosqueName'] ?? 'Local Mosque',
      imam: json['imam'] ?? 'Sheikh',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      description: json['description'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'mosqueName': mosqueName,
      'imam': imam,
      'date': date.toIso8601String(),
      'description': description,
      'audioUrl': audioUrl,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
