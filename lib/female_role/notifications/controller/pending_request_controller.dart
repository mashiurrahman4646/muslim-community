import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';
import 'package:muslim_community/female_role/notifications/service/female_connection_service.dart';
import 'package:muslim_community/female_role/discover/controller/sistergetcontroller.dart';
import 'package:muslim_community/app_config.dart';

class FemalePendingRequestController extends GetxController {
  final FemaleConnectionService _service = FemaleConnectionService();
  
  var isLoading = false.obs;
  var isFetchingMore = false.obs;
  var pendingRequests = <SisterModel>[].obs;
  var nextCursor = RxnString();
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests(isRefresh: true);
  }

  Future<void> fetchPendingRequests({bool isRefresh = false}) async {
    if (isRefresh) {
      isLoading.value = true;
      nextCursor.value = null;
      hasMore.value = true;
    } else {
      if (!hasMore.value || isFetchingMore.value) return;
      isFetchingMore.value = true;
    }

    try {
      final response = await _service.getPendingRequests(); // Service adds direction=received
      print("Pending Requests API Response: ${response.body}");
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        dynamic rawData = responseData['data'];
        List<dynamic> connectionsList = [];
        
        if (rawData is List) {
          connectionsList = rawData;
        } else if (rawData is Map) {
          connectionsList = rawData['results'] ?? rawData['connections'] ?? rawData['requests'] ?? [];
        }

        // Update pagination meta
        final meta = responseData['meta'];
        if (meta != null) {
          nextCursor.value = meta['nextCursor'];
          hasMore.value = meta['hasNext'] ?? false;
        } else {
          hasMore.value = false;
        }
        
        final List<SisterModel> fetchedRequests = connectionsList.map((item) {
          print("DEBUG: RAW PENDING ITEM -> $item");

          // The ID of the connection - checking all possible fields
          final String? connId = (
            item['connectionId'] ?? 
            item['_id'] ?? 
            item['id'] ?? 
            item['connection']?['_id'] ?? 
            item['connection']?['id']
          )?.toString();

          // For 'received' direction, info is in 'sender' or 'requester'
          final json = item['sender'] ?? item['requester'] ?? item['user'] ?? item;
          final String userId = (json['_id'] ?? json['id'] ?? '').toString();
          
          // Handle relative image path
          String imgUrl = json['profileImage'] ?? '';
          if (imgUrl.isNotEmpty && !imgUrl.startsWith('http')) {
            final base = AppConfig.baseUrl.replaceAll('/api/v1', '');
            imgUrl = "$base$imgUrl";
          }
          
          print("Mapped Pending Request: ${json['name']}, connectionId: $connId, userId: $userId");
          
          return SisterModel(
            id: userId,
            connectionId: connId,
            name: json['name'] ?? 'Unknown',
            age: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
            joinedAgo: 'New Revert',
            distance: double.tryParse(json['distanceInKm']?.toString() ?? '0.0') ?? 0.0,
            status: 'Received',
            imageUrl: imgUrl,
            about: json['about'] ?? '',
            interests: json['interests'] != null ? List<String>.from(json['interests']) : [],
          );
        }).toList();

        if (isRefresh) {
          pendingRequests.value = fetchedRequests;
        } else {
          pendingRequests.addAll(fetchedRequests);
        }
      } else {
        print("Failed to fetch pending requests: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching pending requests: $e");
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  Future<void> acceptRequest(String connectionId, String sisterId) async {
    try {
      final response = await _service.acceptConnection(connectionId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        pendingRequests.removeWhere((s) => s.id == sisterId);

        // Update Discovery list if registered
        if (Get.isRegistered<SisterGetController>()) {
          Get.find<SisterGetController>().updateStatus(sisterId, 'Connected');
        }

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
      final response = await _service.rejectConnection(connectionId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        pendingRequests.removeWhere((s) => s.id == sisterId);

        // Update Discovery list if registered (show Connect button again)
        if (Get.isRegistered<SisterGetController>()) {
          Get.find<SisterGetController>().updateStatus(sisterId, 'Connect');
        }

        Get.snackbar("Success", "Connection request rejected");
      } else {
        Get.snackbar("Error", "Failed to reject request");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
