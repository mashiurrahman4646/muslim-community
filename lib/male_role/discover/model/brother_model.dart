class BrotherModel {
  final String name;
  final int age;
  final String joinedAgo;
  final double distance;
  final String status; // 'Connected', 'Connect', 'Requested'
  final bool isVerified;
  final bool isOnline;
  final bool isNewRevert;
  final String imageUrl;
  final String about;
  final String revertHistory;
  final List<String> interests;

  BrotherModel({
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
}
