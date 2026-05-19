import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';
import 'package:muslim_community/male_role/notifications/service/male_connection_service.dart';

class MalePendingRequestController extends GetxController {
  final MaleConnectionService _service = MaleConnectionService();
  
  var isLoading = false.obs;
  var pendingRequests = <BrotherModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  Future<void> fetchPendingRequests() async {
    isLoading.value = true;
    try {
      final response = await _service.getPendingRequests();
      print("Pending Requests API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        dynamic rawData = responseData['data'];
        List<dynamic> connectionsList = [];
        
        if (rawData is List) {
          connectionsList = rawData;
        } else if (rawData is Map) {
          // Sometimes data is a map containing the list in a field like 'results' or 'connections'
          connectionsList = rawData['results'] ?? rawData['connections'] ?? rawData['requests'] ?? [];
        }

        print("Processing ${connectionsList.length} connections");

        pendingRequests.value = connectionsList.map((item) {
          // The item is the connection object. User info is in 'sender' or 'requester'
          final json = item['sender'] ?? item['requester'] ?? item['user'] ?? item;
          
          // Use the ID of the connection object as connectionId
          final String? connId = (item['_id'] ?? item['id'] ?? json['connectionId'])?.toString();
          final String userId = (json['_id'] ?? json['id'] ?? '').toString();
          
          print("Mapped Notification Profile: ${json['name']}, connId: $connId, userId: $userId");

          return BrotherModel(
            id: userId,
            connectionId: connId,
            name: json['name'] ?? 'Unknown',
            age: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
            joinedAgo: 'New Revert',
            distance: double.tryParse(json['distanceInKm']?.toString() ?? '0.0') ?? 0.0,
            status: 'Received',
            imageUrl: json['profileImage'] ?? '',
            about: json['about'] ?? '',
            interests: json['interests'] != null ? List<String>.from(json['interests']) : [],
          );
        }).toList();
        print("Successfully displayed ${pendingRequests.length} pending requests");
      } else {
        print("Failed to fetch pending requests: ${response.statusCode} - ${response.body}");
      }
    } catch (e, stack) {
      print("Error fetching pending requests: $e");
      print("Stack trace: $stack");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptRequest(String connectionId, String brotherId) async {
    try {
      final response = await _service.updateConnectionStatus(connectionId, 'ACCEPT');
      if (response.statusCode == 200) {
        pendingRequests.removeWhere((b) => b.id == brotherId);
        Get.snackbar("Success", "Connection request accepted");
      } else {
        Get.snackbar("Error", "Failed to accept request");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

  Future<void> rejectRequest(String connectionId, String brotherId) async {
    try {
      final response = await _service.updateConnectionStatus(connectionId, 'REJECT');
      if (response.statusCode == 200) {
        pendingRequests.removeWhere((b) => b.id == brotherId);
        Get.snackbar("Success", "Connection request rejected");
      } else {
        Get.snackbar("Error", "Failed to reject request");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
