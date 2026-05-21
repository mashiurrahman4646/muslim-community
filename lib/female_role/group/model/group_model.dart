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
    // 1. Comprehensive check for join status from multiple possible API fields
    bool isJoined = json['isJoined'] == true || 
                    json['isMember'] == true || 
                    json['joined'] == true ||
                    json['is_member'] == true ||
                    json['is_joined'] == true ||
                    json['isJoined']?.toString().toLowerCase() == 'true' ||
                    json['isMember']?.toString().toLowerCase() == 'true' ||
                    json['joined']?.toString().toLowerCase() == 'true' ||
                    // Check if current user is the creator of the group
                    json['userId']?.toString() == currentUserId ||
                    json['creator']?.toString() == currentUserId ||
                    json['creatorId']?.toString() == currentUserId;
    
    // 2. If direct fields are not true, check the members list manually
    if (!isJoined && json['members'] != null && currentUserId != null && currentUserId.isNotEmpty) {
      final membersList = json['members'];
      if (membersList is List) {
        isJoined = membersList.any((member) {
          if (member == null) return false;
          
          // Case: member is a String ID
          if (member is String) {
            return member == currentUserId;
          } 
          // Case: member is a Map with ID (check common ID keys)
          else if (member is Map) {
            final memberId = member['id']?.toString() ?? 
                             member['_id']?.toString() ?? 
                             member['userId']?.toString() ?? 
                             member['user']?.toString() ?? 
                             member['member']?.toString() ?? '';
            return memberId == currentUserId;
          }
          return false;
        });
      }
    }

    return GroupModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      memberCount: json['memberCount'] is int ? json['memberCount'] : int.tryParse(json['memberCount']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? '',
      userType: json['userType']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      isJoined: isJoined,
      icon: _getIconForCategory(json['category']?.toString() ?? ''),
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
