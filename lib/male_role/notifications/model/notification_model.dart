import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String body;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool isUnread;

  NotificationModel({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.isUnread = false,
  });
}
