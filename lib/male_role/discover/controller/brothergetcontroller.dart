import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';
import 'package:muslim_community/male_role/discover/service/brothergetservice.dart';

import 'package:muslim_community/male_role/home/controller/userdatacontroller.dart';

class BrotherGetController extends GetxController {
  final BrotherGetService _service = BrotherGetService();
  final MaleUserDataController _userCtrl = Get.find<MaleUserDataController>();
  
  var isLoading = false.obs;
  var brothers = <BrotherModel>[].obs;
  var searchTerm = "".obs;
  var filter = "nearby-me".obs;
  var page = 1.obs;
  var hasMore = true.obs;
  var isFetchingMore = false.obs;

  Future<void> fetchBrothers({bool isRefresh = false}) async {
    if (isRefresh) {
      page.value = 1;
      hasMore.value = true;
      isLoading.value = true;
    } else {
      if (!hasMore.value || isFetchingMore.value) return;
      isFetchingMore.value = true;
    }
    
    try {
      double latitude = 23.779999;
      double longitude = 90.406693;
      
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 3),
        );
        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        print("Geolocator failed in discover, using fallback coordinates: $e");
      }

      final response = await _service.getProfiles(
        latitude: latitude,
        longitude: longitude,
        searchTerm: searchTerm.value,
        filter: filter.value,
        page: page.value,
        limit: 10,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> profilesData = responseData['data'] ?? [];
        
        if (profilesData.isEmpty) {
          hasMore.value = false;
          if (isRefresh) {
            brothers.clear();
          }
        } else {
          final fetchedBrothers = profilesData.map((json) {
            final int age = json['age'] ?? 30;
            String joinedAgo = 'New Revert';
            if (json['revertDate'] != null) {
              try {
                final DateTime revertDate = DateTime.parse(json['revertDate']);
                final int differenceInDays = DateTime.now().difference(revertDate).inDays;
                if (differenceInDays > 365) {
                  joinedAgo = '${(differenceInDays / 365).floor()} years ago';
                } else if (differenceInDays > 30) {
                  joinedAgo = '${(differenceInDays / 30).floor()} months ago';
                } else {
                  joinedAgo = '$differenceInDays days ago';
                }
              } catch (e) {
                joinedAgo = 'New Revert';
              }
            }
            
            String rawStatus = (json['connectionStatus'] ?? json['status'] ?? '').toString().toLowerCase();
            String mappedStatus = 'Connect';
            
            // Get connection data if it exists
            final connection = json['connection'] ?? json['connectionData'];
            final senderId = connection != null ? (connection['sender'] ?? connection['requester']) : null;
            final currentUserId = _userCtrl.userId.value;

            if (rawStatus == 'received' || rawStatus == 'incoming') {
              mappedStatus = 'Received';
            } else if (rawStatus == 'pending' || rawStatus == 'requested' || rawStatus == 'sent') {
              // If it's pending, check if I am the sender or receiver
              if (senderId != null && currentUserId.isNotEmpty && senderId.toString() != currentUserId) {
                mappedStatus = 'Received';
              } else {
                mappedStatus = 'Requested';
              }
            } else if (rawStatus == 'accepted' || rawStatus == 'connected' || rawStatus == 'friends') {
              mappedStatus = 'Connected';
            }

            // Log connection-related fields to debug
            if (mappedStatus != 'Connect') {
              print("=== PROFILE WITH CONNECTION STATUS ===");
              print("  name: ${json['name']}");
              print("  rawStatus: $rawStatus");
              print("  mappedStatus: $mappedStatus");
              print("  senderId: $senderId");
              print("  currentUserId: $currentUserId");
              print("  connectionStatus: ${json['connectionStatus']}");
              print("  connectionId: ${json['connectionId']}");
            }

            return BrotherModel(
              id: json['_id'] ?? json['id'] ?? '',
              connectionId: json['connectionId']?.toString(),
              name: json['name'] ?? 'Unknown',
              age: age,
              joinedAgo: joinedAgo,
              distance: json['distanceInKm'] != null 
                  ? double.parse((json['distanceInKm'] as double).toStringAsFixed(1)) 
                  : 0.0,
              status: mappedStatus,
              isVerified: json['isVerified'] ?? false,
              isOnline: false,
              isNewRevert: filter.value == 'new-reverts',
              imageUrl: json['profileImage'] ?? '',
              about: json['about'] ?? 'No information provided yet.',
              revertHistory: json['revertHistory'] ?? 'No revert history provided yet.',
              interests: List<String>.from(json['interests'] ?? []),
            );
          }).toList();

          if (isRefresh) {
            brothers.value = fetchedBrothers;
          } else {
            brothers.addAll(fetchedBrothers);
          }
          page.value++;
        }
      } else {
        print("Failed to fetch brothers. Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching brothers in controller: $e");
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    debounce(searchTerm, (_) => fetchBrothers(isRefresh: true), time: const Duration(milliseconds: 500));
  }

  void searchBrothers(String query) {
    searchTerm.value = query;
  }

  void changeFilter(String newFilter) {
    filter.value = newFilter;
    fetchBrothers(isRefresh: true);
  }

  void updateStatus(String id, String newStatus, {String? connectionId}) {
    int index = brothers.indexWhere((b) => b.id == id);
    if (index != -1) {
      brothers[index] = brothers[index].copyWith(
        status: newStatus,
        connectionId: connectionId ?? brothers[index].connectionId,
      );
      brothers.refresh(); // Force UI update
    }
  }
}
