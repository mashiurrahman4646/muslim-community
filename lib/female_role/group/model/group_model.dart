import 'package:flutter/material.dart';

class GroupModel {
  final String id;
  final String name;
  final String category;
  final int memberCount;
  final String description;
  final bool isJoined;
  final IconData icon;

  GroupModel({
    required this.id,
    required this.name,
    required this.category,
    required this.memberCount,
    required this.description,
    this.isJoined = false,
    required this.icon,
  });
}
