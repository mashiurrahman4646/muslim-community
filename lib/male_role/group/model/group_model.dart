import 'package:flutter/material.dart';

class GroupModel {
  final String id;
  final String name;
  final String category;
  final int memberCount;
  final String description;
  final bool isJoined;
  final String userType;
  final String coverImage;
  final IconData icon;

  GroupModel({
    required this.id,
    required this.name,
    required this.category,
    required this.memberCount,
    required this.description,
    this.isJoined = false,
    this.userType = "",
    this.coverImage = "",
    this.icon = Icons.group_outlined,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    bool isJoined = json['isJoined'] ?? json['isMember'] ?? json['joined'] ?? false;
    
    if (!isJoined && json['members'] != null && currentUserId != null && currentUserId.isNotEmpty) {
      final membersList = json['members'];
      if (membersList is List) {
        isJoined = membersList.any((member) {
          if (member is String) {
            return member == currentUserId;
          } else if (member is Map) {
            final memberId = member['id'] ?? member['_id'] ?? '';
            return memberId.toString() == currentUserId;
          }
          return false;
        });
      }
    }

    return GroupModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      description: json['description'] ?? '',
      userType: json['userType'] ?? '',
      coverImage: json['coverImage'] ?? '',
      isJoined: isJoined,
      icon: _getIconForCategory(json['category'] ?? ''),
    );
  }

  static IconData _getIconForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('education') || cat.contains('lessi')) {
      return Icons.school_outlined;
    } else if (cat.contains('local')) {
      return Icons.location_on_outlined;
    } else if (cat.contains('learning')) {
      return Icons.menu_book_outlined;
    } else if (cat.contains('support')) {
      return Icons.favorite_border_outlined;
    } else if (cat.contains('community')) {
      return Icons.people_outline;
    }
    return Icons.group_outlined;
  }
}
