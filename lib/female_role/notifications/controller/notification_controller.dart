import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/notifications/model/notification_model.dart';

class FemaleNotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    notifications.value = [
      NotificationModel(
        title: 'Time for Asr',
        body: 'It is time to pray Asr in your location.',
        timeAgo: 'Just now',
        icon: Icons.access_time_filled,
        iconColor: const Color(0xFFA6864D),
        iconBackgroundColor: const Color(0xFFFDF8F1),
        isUnread: true,
      ),
      NotificationModel(
        title: 'Connection Accepted',
        body: 'Omar H. accepted your connection request.',
        timeAgo: '2h ago',
        icon: Icons.person_add_alt_1_rounded,
        iconColor: const Color(0xFF5B7C99),
        iconBackgroundColor: const Color(0xFFF0F4F7),
        isUnread: true,
      ),
      NotificationModel(
        title: 'Event Reminder',
        body: 'Grand Iftar & Halaqa starts tomorrow.',
        timeAgo: '5h ago',
        icon: Icons.calendar_today_rounded,
        iconColor: const Color(0xFFD18E8E),
        iconBackgroundColor: const Color(0xFFFDF1F1),
        isUnread: false,
      ),
      NotificationModel(
        title: 'New Message',
        body: 'Yusuf: InshaAllah see you at Jummah',
        timeAgo: '1d ago',
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: const Color(0xFF436E50),
        iconBackgroundColor: const Color(0xFFF1FDF4),
        isUnread: false,
      ),
    ];
  }

  void markAllAsRead() {
    loadNotifications(); // Reload or update list
  }
}
