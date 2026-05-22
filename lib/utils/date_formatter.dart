import 'package:intl/intl.dart';

class DateFormatter {
  static String formatChatTime(String dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      // Handle ISO strings like 2026-05-21T22:04:44.673Z
      DateTime dateTime = DateTime.parse(dateStr).toLocal();
      DateTime now = DateTime.now();
      
      if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
        return DateFormat('hh:mm a').format(dateTime);
      } else if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day - 1) {
        return 'Yesterday';
      } else {
        return DateFormat('dd/MM/yy').format(dateTime);
      }
    } catch (e) {
      return dateStr;
    }
  }

  static String formatPostTime(String dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(dateStr).toLocal();
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('dd MMM yyyy').format(dateTime);
      }
    } catch (e) {
      return dateStr;
    }
  }
}
