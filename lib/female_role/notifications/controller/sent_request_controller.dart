import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';
import 'package:muslim_community/female_role/notifications/service/female_connection_service.dart';
import 'package:muslim_community/female_role/discover/controller/sistergetcontroller.dart';
import 'package:muslim_community/app_config.dart';

class FemaleSentRequestController extends GetxController {
  final FemaleConnectionService _service = FemaleConnectionService();
  
  var isLoading = false.obs;
  var isFetchingMore = false.obs;
  var sentRequests = <SisterModel>[].obs;
  var nextCursor = RxnString();
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSentRequests(isRefresh: true);
  }

  Future<void> fetchSentRequests({bool isRefresh = false}) async {
    if (isRefresh) {
      isLoading.value = true;
      nextCursor.value = null;
      hasMore.value = true;
    } else {
      if (!hasMore.value || isFetchingMore.value) return;
      isFetchingMore.value = true;
    }

    try {
      final response = await _service.getSentRequests(nextCursor: nextCursor.value);
      print("Sent Requests API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        dynamic rawData = responseData['data'];
        List<dynamic> connectionsList = [];
        
        if (rawData is List) {
          connectionsList = rawData;
        } else if (rawData is Map) {
          connectionsList = rawData['results'] ?? rawData['connections'] ?? rawData['requests'] ?? [];
        }

        // Update meta for pagination
        final meta = responseData['meta'];
        if (meta != null) {
          nextCursor.value = meta['nextCursor'];
          hasMore.value = meta['hasNext'] ?? false;
        } else {
          hasMore.value = false;
        }

        final List<SisterModel> fetchedRequests = connectionsList.map((item) {
          print("DEBUG: RAW SENT ITEM -> $item");

          // The ID of the connection - checking all possible fields
          final String? connId = (
            item['connectionId'] ?? 
            item['_id'] ?? 
            item['id'] ?? 
            item['connection']?['_id'] ?? 
            item['connection']?['id']
          )?.toString();

          // In 'sent' direction, receiver info is in 'receiver' or 'recipient'
          final json = item['receiver'] ?? item['recipient'] ?? item['user'] ?? item;
          final String userId = (json['_id'] ?? json['id'] ?? '').toString();
          
          // Handle relative image path
          String imgUrl = json['profileImage'] ?? '';
          if (imgUrl.isNotEmpty && !imgUrl.startsWith('http')) {
            final base = AppConfig.baseUrl.replaceAll('/api/v1', '');
            imgUrl = "$base$imgUrl";
          }

          print("Mapped Sent Request: ${json['name']}, connectionId: $connId, userId: $userId");

          return SisterModel(
            id: userId,
            connectionId: connId,
            name: json['name'] ?? 'Unknown',
            age: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
            joinedAgo: 'New Revert',
            distance: double.tryParse(json['distanceInKm']?.toString() ?? '0.0') ?? 0.0,
            status: 'Requested',
            imageUrl: imgUrl,
            about: json['about'] ?? '',
            interests: json['interests'] != null ? List<String>.from(json['interests']) : [],
          );
        }).toList();

        if (isRefresh) {
          sentRequests.value = fetchedRequests;
        } else {
          sentRequests.addAll(fetchedRequests);
        }
      } else {
        print("Failed to fetch sent requests: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching sent requests: $e");
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  Future<void> cancelRequest(String connectionId, String sisterId) async {
    print("🔔 CANCEL REQUEST CALLED");
    print("   connectionId: $connectionId");
    print("   sisterId    : $sisterId");
    
    try {
      final response = await _service.cancelConnection(connectionId);
      print("   Status Code: ${response.statusCode}");
      print("   Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("   ✅ SUCCESS: Removing from list");
        sentRequests.removeWhere((s) => s.id == sisterId || s.connectionId == connectionId);
        sentRequests.refresh();
        
        // Also update discovery list if registered
        if (Get.isRegistered<SisterGetController>()) {
          Get.find<SisterGetController>().updateStatus(sisterId, 'Connect');
        }
        
        Get.snackbar("Success", "Connection request cancelled");
      } else {
        print("   ❌ FAILED: ${response.body}");
        final error = jsonDecode(response.body);
        Get.snackbar("Error", error['message'] ?? "Failed to cancel request");
      }
    } catch (e) {
      print("   💥 ERROR: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}
