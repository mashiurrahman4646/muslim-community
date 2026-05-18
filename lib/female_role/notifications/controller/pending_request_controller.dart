import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';
import 'package:muslim_community/female_role/notifications/service/female_connection_service.dart';

class FemalePendingRequestController extends GetxController {
  final FemaleConnectionService _service = FemaleConnectionService();
  
  var isLoading = false.obs;
  var pendingRequests = <SisterModel>[].obs;

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
          // The item is the connection object. User info could be in 'sender', 'requester', or 'user'
          final json = item['sender'] ?? item['requester'] ?? item['user'] ?? item;
          
          // The connection ID is the ID of the 'item' itself
          final connectionId = item['_id'] ?? item['id'] ?? json['connectionId'];
          
          // Extract user ID from the nested object or use the top level if it's already a user
          final userId = (json['_id'] ?? json['id'] ?? '').toString();
          
          return SisterModel(
            id: userId,
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

  Future<void> acceptRequest(String connectionId, String sisterId) async {
    try {
      final response = await _service.updateConnectionStatus(connectionId, 'ACCEPT');
      if (response.statusCode == 200) {
        pendingRequests.removeWhere((s) => s.id == sisterId);
        Get.snackbar("Success", "Connection request accepted");
      } else {
        Get.snackbar("Error", "Failed to accept request");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

  Future<void> rejectRequest(String connectionId, String sisterId) async {
    try {
      final response = await _service.updateConnectionStatus(connectionId, 'REJECT');
      if (response.statusCode == 200) {
        pendingRequests.removeWhere((s) => s.id == sisterId);
        Get.snackbar("Success", "Connection request rejected");
      } else {
        Get.snackbar("Error", "Failed to reject request");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
