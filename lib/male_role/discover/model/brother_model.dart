class BrotherModel {
  final String id;
  final String? connectionId;
  final String name;
  final int age;
  final String joinedAgo;
  final double distance;
  final String status; // 'Connected', 'Connect', 'Requested', 'Received'
  final bool isVerified;
  final bool isOnline;
  final bool isNewRevert;
  final String imageUrl;
  final String about;
  final String revertHistory;
  final List<String> interests;

  BrotherModel({
    required this.id,
    this.connectionId,
    required this.name,
    required this.age,
    required this.joinedAgo,
    required this.distance,
    required this.status,
    this.isVerified = false,
    this.isOnline = false,
    this.isNewRevert = false,
    required this.imageUrl,
    this.about = 'No information provided yet.',
    this.revertHistory = 'No revert history provided yet.',
    this.interests = const [],
  });

  BrotherModel copyWith({
    String? id,
    String? connectionId,
    String? name,
    int? age,
    String? joinedAgo,
    double? distance,
    String? status,
    bool? isVerified,
    bool? isOnline,
    bool? isNewRevert,
    String? imageUrl,
    String? about,
    String? revertHistory,
    List<String>? interests,
  }) {
    return BrotherModel(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      name: name ?? this.name,
      age: age ?? this.age,
      joinedAgo: joinedAgo ?? this.joinedAgo,
      distance: distance ?? this.distance,
      status: status ?? this.status,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      isNewRevert: isNewRevert ?? this.isNewRevert,
      imageUrl: imageUrl ?? this.imageUrl,
      about: about ?? this.about,
      revertHistory: revertHistory ?? this.revertHistory,
      interests: interests ?? this.interests,
    );
  }
}
