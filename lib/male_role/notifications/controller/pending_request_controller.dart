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
        final List<dynamic> data = responseData['data'] ?? [];
        
        pendingRequests.value = data.map((item) {
          final json = item['sender'] ?? item['user'] ?? item;
          final connectionId = item['_id'] ?? item['id'] ?? json['connectionId'];
          
          return BrotherModel(
            id: (json['_id'] ?? json['id'] ?? '').toString(),
            connectionId: connectionId?.toString(),
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
        print("Successfully mapped ${pendingRequests.length} pending requests");
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
